class Sample < Formula
  homepage "https://github.com/alexpreynolds/sample"
  # tag "bioinformatics"

  url "https://github.com/alexpreynolds/sample/archive/v1.0.2.tar.gz"
  sha256 "d534a8c85566eaf6eb62b28acb83536cc0b075462cf75532c9df94069a426b45"

  head "https://github.com/alexpreynolds/sample.git"
  version "1.0.2"

  bottle do
    cellar :any_skip_relocation
    sha256 "4c5a2dfda0ea2658bc505ef5bdf47a199b810fe36f20a8fffe275395afc1cc80" => :el_capitan
    sha256 "5faad7689e3ced8019f9f9833f629f581237922753fa8ff3785f8e23c5f48eab" => :yosemite
    sha256 "18f3d8dbcd1bb202eb913c7238e5249dcf0ea98996306ecedbe090d2d56e5e91" => :mavericks
  end

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
