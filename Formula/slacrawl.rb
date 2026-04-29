class Slacrawl < Formula
  desc "Go-based CLI for mirroring Slack workspace data into local SQLite"
  homepage "https://github.com/vincentkoc/slacrawl"
  url "https://github.com/vincentkoc/slacrawl/archive/refs/tags/v0.6.1.tar.gz"
  sha256 "a6890a5c7e09c546694223712521ca3a9b727be60d469cf6fea836d9f45a680b"
  license "MIT"
  version "0.6.1"

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w"), "./cmd/slacrawl"
    pkgshare.install "config.example.toml"
    doc.install "README.md", "LICENSE", "SPEC.md"
  end

  test do
    assert_match "Usage of slacrawl:", shell_output("#{bin}/slacrawl --help", 1)
  end
end
