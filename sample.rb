class Sample < Formula
  desc "`sample` performs reservoir sampling with or without replacement, scaling to larger inputs than GNU `shuf`"
  homepage "https://github.com/alexpreynolds/sample"
  # tag "bioinformatics"

  url "https://github.com/alexpreynolds/sample/archive/v1.0.2.tar.gz"
  sha256 "d534a8c85566eaf6eb62b28acb83536cc0b075462cf75532c9df94069a426b45"

  head "https://github.com/alexpreynolds/sample.git"
  version "1.0.2"

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
