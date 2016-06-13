class Sample < Formula
  desc "Memory-efficient reservoir sampling"
  homepage "https://github.com/alexpreynolds/sample"
  # tag "bioinformatics"

  url "https://github.com/alexpreynolds/sample/archive/v1.0.3.tar.gz"
  sha256 "bf51add658edf75693601a993ce19a7f0e156888cbd95579551c154856e4759c"

  head "https://github.com/alexpreynolds/sample.git"

  env :std

  def install
    ENV.O3
    ENV.delete("CFLAGS")
    ENV.delete("CXXFLAGS")
    system "make", "build"
    bin.install "sample"
    doc.install %w[LICENSE README.md]
  end

  test do
    system "make", "check"
  end
end
