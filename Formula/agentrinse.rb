# frozen_string_literal: true

# Homebrew formula for AgentRinse.
class Agentrinse < Formula
  desc "Fail-closed cleanup for developer agent state and Git worktrees"
  homepage "https://github.com/vincentkoc/agentrinse"
  url "https://github.com/vincentkoc/agentrinse/releases/download/v0.5.0/agentrinse-0.5.0.tgz"
  sha256 "9d109dd465f6f69ff27c329dd53b0e9c8ddd54674e7fbabf84e07e96ca9dbe13"
  license "MIT"

  depends_on "node"

  def install
    system "npm", "install", *std_npm_args
    bin.install_symlink libexec.glob("bin/*")
  end

  test do
    assert_equal version.to_s, shell_output("#{bin}/agentrinse --version").strip

    home = testpath/"home"
    (home/".codex/sessions").mkpath
    output = shell_output("#{bin}/agentrinse audit --home #{home} --json")
    assert_match '"command": "audit"', output
    assert_match '"schemaVersion": 1', output
  end
end
