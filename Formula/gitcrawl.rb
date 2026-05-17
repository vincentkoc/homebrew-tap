class Gitcrawl < Formula
  desc "Local GitHub issue and PR archive with gh-compatible caching"
  homepage "https://github.com/openclaw/gitcrawl"
  version "0.4.0"
  license "MIT"

  on_macos do
    if Hardware::CPU.arm?
      url "https://github.com/openclaw/gitcrawl/releases/download/v0.4.0/gitcrawl_0.4.0_darwin_arm64.tar.gz"
      sha256 "979f595e8e91fa7bcb427189c8fa3a7409a1363e221639bb1495223ad88fe5cf"
    else
      url "https://github.com/openclaw/gitcrawl/releases/download/v0.4.0/gitcrawl_0.4.0_darwin_amd64.tar.gz"
      sha256 "c6225bb9e2102a51833ad82019b5b535296e31a77ac2f3d56f61c1df68b48f0f"
    end
  end

  on_linux do
    if Hardware::CPU.arm? && Hardware::CPU.is_64_bit?
      url "https://github.com/openclaw/gitcrawl/releases/download/v0.4.0/gitcrawl_0.4.0_linux_arm64.tar.gz"
      sha256 "bb958a84e0f1f22395952fc1030eb6b27633c78b7cbced4d17d2250670dfd5f3"
    else
      url "https://github.com/openclaw/gitcrawl/releases/download/v0.4.0/gitcrawl_0.4.0_linux_amd64.tar.gz"
      sha256 "2f3afa7cae5f87f7b518737ce6594e21e72b922616ed34ef2dbf33118d945fc7"
    end
  end

  def install
    bin.install "gitcrawl"
  end

  test do
    assert_equal version.to_s, shell_output("#{bin}/gitcrawl --version").strip
  end
end
