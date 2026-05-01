class Gitcrawl < Formula
  desc "Local-first GitHub issue and pull request crawler for maintainer triage"
  homepage "https://github.com/openclaw/gitcrawl"
  url "https://github.com/openclaw/gitcrawl/archive/refs/tags/v0.1.1.tar.gz"
  sha256 "d986ca45e457119308e9fd7403a9054eb82d3396ccf15b3b1b4565cd6e15218c"
  license "MIT"

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w -X github.com/openclaw/gitcrawl/internal/cli.version=#{version}"), "./cmd/gitcrawl"
    doc.install "README.md", "LICENSE", "SPEC.md"
  end

  test do
    assert_equal version.to_s, shell_output("#{bin}/gitcrawl --version").strip
  end
end
