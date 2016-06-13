class Nest < Formula
  desc "The Neural Simulation Tool"
  homepage "http://www.nest-simulator.org/"
  url "https://github.com/nest/nest-simulator/releases/download/v2.10.0/nest-2.10.0.tar.gz"
  sha256 "2b6fc562cd6362e812d94bb742562a5a685fb1c7e08403765dbe123d59b0996c"

  head "https://github.com/nest/nest-simulator.git"

  bottle do
    revision 1
    sha256 "5fbbaae56cc28ad78710caf7466823c1740d4476b1ac48e908ab2926fbe8239c" => :el_capitan
    sha256 "dc48e004857285debafd4b1e87ad3cdf24a78c22d4e3c33147736005b298fc78" => :yosemite
    sha256 "7145a085a494492c9f6a5bf496209b8003e6082ed6f4a5e7f549d3fb99f73f1d" => :mavericks
  end

  option "with-python", "Build Python bindings (PyNEST)."
  option "without-openmp", "Build without OpenMP support."
  needs :openmp if build.with? "openmp"

  depends_on "gsl" => :recommended
  depends_on :mpi => [:optional, :cc, :cxx]
  depends_on :python => :optional if MacOS.version <= :snow_leopard
  depends_on "numpy" => :python if build.with? "python"
  depends_on "scipy" => :python if build.with? "python"
  depends_on "matplotlib" => :python if build.with? "python"
  depends_on "cython" => :python if build.with? "python"
  depends_on "nose" => :python if build.with? "python"
  depends_on "libtool" => :run
  depends_on "readline" => :run
  depends_on "autoconf" => :build unless build.head?
  depends_on "automake" => :build unless build.head?
  depends_on "cmake" => :build if build.head?

  fails_with :clang do
    cause <<-EOS.undent
      Building NEST with clang is not stable. See https://github.com/nest/nest-simulator/issues/74 .
    EOS
  end

  env :std

  def install
    ENV.delete("CFLAGS")
    ENV.delete("CXXFLAGS")

    if build.head?
      args = ["-DCMAKE_INSTALL_PREFIX:PATH=#{prefix}"]

      args << "-Dwith-mpi=ON" if build.with? "mpi"
      args << "-Dwith-openmp=OFF" if build.without? "openmp"
      args << "-Dwith-gsl=OFF" if build.without? "gsl"
      args << "-Dwith-python=OFF" if build.without? "python"

      # "out of source" build
      mkdir "build" do
        system "cmake", "..", *args
        system "make"
        system "make", "install"
      end
      return
    end

    args = ["--disable-debug",
            "--disable-dependency-tracking",
            "--prefix=#{prefix}",
           ]

    if build.with? "mpi"
      # change CC / CXX in open-mpi
      ENV["OMPI_CC"] = ENV["CC"]
      ENV["OMPI_CXX"] = ENV["CXX"]

      # change CC / CXX in mpich
      ENV["MPICH_CC"] = ENV["CC"]
      ENV["MPICH_CXX"] = ENV["CXX"]

      args << "CC=#{ENV["MPICC"]}"
      args << "CXX=#{ENV["MPICXX"]}"
      args << "--with-mpi"
    end

    args << "--without-openmp" if build.without? "openmp"
    args << "--without-gsl" if build.without? "gsl"
    args << "--without-python" if build.without? "python"

    # "out of source" build
    mkdir "build" do
      system "../configure", *args
      # adjust src and bld path
      inreplace "../sli/slistartup.cc", /PKGSOURCEDIR/, "\"#{pkgshare}/sources\""
      inreplace "libnestutil/sliconfig.h", /#define SLI_BUILDDIR .*/, "#define SLI_BUILDDIR \"#{pkgshare}/sources/build\""
      # do not re-generate .hlp during /validate (tries to regenerate from
      # not existing source file)
      inreplace "../lib/sli/helpinit.sli", /^ makehelp$/, "% makehelp"
      system "make"
      system "make", "install"
    end

    # install sources for later testing
    mkdir pkgshare/"sources"
    (pkgshare/"sources").install Dir["./*"]
  end

  test do
    # simple check whether NEST was compiled & linked
    system bin/"nest", "--version"

    # necessary for the python tests
    ENV["exec_prefix"] = prefix
    # if build.head? does not seem to work
    if !File.directory?(pkgshare/"sources")
      # Skip tests for correct copyright headers
      ENV["NEST_SOURCE"] = "SKIP"
    else
      # necessary for one regression on the sources
      ENV["NEST_SOURCE"] = pkgshare/"sources"
    end

    if build.with? "mpi"
      # we need the command /mpirun defined for the mpi tests
      # and since we are in the sandbox, we create it again
      nestrc = %{
        /mpirun
        [/integertype /stringtype]
        [/numproc     /slifile]
        {
         () [
          (mpirun -np ) numproc cvs ( ) statusdict/prefix :: (/bin/nest )  slifile
         ] {join} Fold
        } Function def
      }
      File.open(ENV["HOME"]+"/.nestrc", "w") { |file| file.write(nestrc) }
    end

    # run all tests
    args = []
    args << "--test-pynest" if build.with? "python"
    system pkgshare/"extras/do_tests.sh", *args
  end
end
