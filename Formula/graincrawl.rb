class Graincrawl < Formula
  desc "Local-first Granola crawler into SQLite and Markdown"
  homepage "https://github.com/vincentkoc/graincrawl"
  url "https://github.com/vincentkoc/graincrawl.git",
      tag: "v0.1.0",
      revision: "03e4ab8ee610645461740e7d40beb880930542e8"
  license "MIT"
  version "0.1.0"

  depends_on "go" => :build

  def install
    ldflags = "-s -w " \
              "-X github.com/vincentkoc/graincrawl/internal/buildinfo.Version=#{version}"
    system "go", "build", *std_go_args(ldflags: ldflags), "./cmd/graincrawl"
    pkgshare.install "config.example.toml"
    doc.install "README.md", "LICENSE", "SPEC.md"
  end

  test do
    assert_match '"version"', shell_output("#{bin}/graincrawl version --json")
    assert_match "graincrawl archives Granola", shell_output("#{bin}/graincrawl --help")
  end
end
