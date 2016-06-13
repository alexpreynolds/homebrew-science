class Sample < Formula
  desc "Memory-efficient reservoir sampling"
  homepage "https://github.com/alexpreynolds/sample"
  # tag "bioinformatics"

  url "https://github.com/alexpreynolds/sample/archive/v1.0.3.tar.gz"
  sha256 "bf51add658edf75693601a993ce19a7f0e156888cbd95579551c154856e4759c"

  head "https://github.com/alexpreynolds/sample.git"

  def install
    ENV.O3
    ENV.delete("CFLAGS")
    ENV.delete("CXXFLAGS")
    system "make", "build"
    bin.install "sample"
    doc.install %w[LICENSE README.md]
  end

  test do
    require "tmpdir"
    require "open3"
    temp_dir = Dir.mktmpdir
    begin
      open("#{temp_dir}/original.txt", "w") { |t| t.puts ["1", "2", "3", "4", "5"].join("\n") }
      stdout, _stderr, status = Open3.capture3("#{bin}/sample", "--rng-seed=123456", "#{temp_dir}/original.txt")
      if status != 0
        puts "sample failed with non-zero error - test failed"
        exit status
      end
      shuffled_original = stdout.dup.delete("\n")
      unless shuffled_original == ["4", "2", "1", "3", "5"].join("")
        puts "sample observed output not matching expected output - test failed"
        exit 1
      end
    ensure
      remove_entry_secure temp_dir
    end
  end
end
