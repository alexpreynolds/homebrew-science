class Bedops < Formula
  homepage 'https://github.com/bedops/bedops'
  #doi "10.1093/bioinformatics/bts277"
  #tag "bioinformatics"

  url "https://github.com/bedops/bedops/archive/v2.4.10.tar.gz"
  sha1 "bd20a992b59374ca0f4c3960f304a6291dbd8df6"

  head 'https://github.com/bedops/bedops.git'

  bottle do
    root_url "https://downloads.sf.net/project/machomebrew/Bottles/science"
    cellar :any
    sha1 "3cff73ec407a24a2a36aec9a3c5893cfa8f2f1d7" => :yosemite
    sha1 "bd2bedd2b2a3dfd6183add4dd6476d48dec60064" => :mavericks
    sha1 "b711ccdf08b17c4ae4f6d099cfee727145e717af" => :mountain_lion
  end

  env :std

  fails_with :gcc do
    build 5666
    cause 'BEDOPS toolkit requires a C++11 compliant compiler'
  end

  def install
    ENV.O3
    ENV.delete('CFLAGS')
    ENV.delete('CXXFLAGS')
    system 'make'
    system 'make', 'install'
    bin.install Dir['bin/*']
    doc.install %w[LICENSE README.md]
  end

  test do
    system "#{bin}/bedops", '--version'
  end
end
