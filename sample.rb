class Sample < Formula
  desc "This tool performs reservoir sampling (Vitter, 'Random sampling with a reservoir'; cf. http://dx.doi.org/10.1145/3147.3165 and also: http://en.wikipedia.org/wiki/Reservoir_sampling) with or without replacement on very large text files that are delimited by newline characters (such as common genomic data formats like BED, SAM, VCF, etc.) and scales to larger inputs than GNU shuf by sampling line offsets, instead of whole lines."
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
