class Butterflow < Formula
  desc "Makes fluid slow motion and motion interpolated videos"
  homepage "https://github.com/dthpham/butterflow"
  url "http://srv.dthpham.me/butterflow/butterflow-0.2.0.tar.gz"
  sha256 "dc70927d78193543b4b364573e0cf2d0881a54483aa306db51cd9f57cf23781e"
  revision 2

  bottle do
    cellar :any
    sha256 "4874a72d9625d7b509c6fdf79ddc77548b18168554118bf56979a3160cb5c095" => :el_capitan
    sha256 "27d69b0885c38a457a80ff22cdb06b1bf44b05acdd78f559090de807ecd42b04" => :yosemite
    sha256 "06cb9b8b194f058c8c242a28d52315b016077fc7916b89c6096302dade88e07a" => :mavericks
  end

  # To satisfy OpenCL 1.2 requirement
  depends_on :macos => :mavericks

  depends_on "ffmpeg"
  depends_on "opencv" => ["with-ffmpeg", "with-opengl"]

  def install
    ENV.prepend_path "PYTHONPATH", Formula["numpy"].opt_lib/"python2.7/site-packages"
    ENV.prepend_path "PYTHONPATH", Formula["opencv"].opt_lib/"python2.7/site-packages"
    ENV.prepend_create_path "PYTHONPATH", libexec/"lib/python2.7/site-packages"
    system "python", *Language::Python.setup_install_args(libexec)
    bin.install Dir["#{libexec}/bin/*"]
    bin.env_script_all_files(libexec/"bin", :PYTHONPATH => ENV["PYTHONPATH"])
  end

  test do
    system "#{bin}/butterflow", "-d"
  end
end
