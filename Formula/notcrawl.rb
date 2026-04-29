class Notcrawl < Formula
  desc "Local-first Notion crawler into SQLite and normalized Markdown"
  homepage "https://github.com/vincentkoc/notcrawl"
  url "https://github.com/vincentkoc/notcrawl/archive/refs/tags/v0.3.5.tar.gz"
  sha256 "4a5ce1606006a96c59a27b04cc69ed6d081befecd59029f69941960d6f1113dc"
  license "MIT"
  version "0.3.5"

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w"), "./cmd/notcrawl"
    pkgshare.install "config.example.toml"
    doc.install "README.md", "LICENSE", "SPEC.md"
  end

  test do
    assert_match "Usage of notcrawl:", shell_output("#{bin}/notcrawl --help")
  end
end
