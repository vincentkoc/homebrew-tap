# frozen_string_literal: true

require "json"

# Homebrew formula for AgentRinse.
class Agentrinse < Formula
  desc "Fail-closed cleanup for developer agent state and Git worktrees"
  homepage "https://github.com/vincentkoc/agentrinse"
  url "https://github.com/vincentkoc/agentrinse/releases/download/v0.8.2/agentrinse-0.8.2.tgz"
  sha256 "1c30fc4f77d0254aa9ed11cf364299263519a8b44ead17c99ce9f4cdd6296ce9"
  license "MIT"
  revision 1

  depends_on "node"

  def install
    # Keep npm on the declared Node toolchain when PATH contains another Node.
    node = Formula["node"]
    ENV.prepend_path "PATH", node.opt_bin
    system "npm", "install", *std_npm_args
    bin.install_symlink libexec.glob("bin/*")
  end

  test do
    assert_equal version.to_s, shell_output("#{bin}/agentrinse --version").strip

    home = testpath/"home"
    cursor = home/"Library/Application Support/Cursor"
    copilot = home/".copilot"
    opencode = home/".local/share/opencode"

    (cursor/"User/workspaceStorage/workspace").mkpath
    (cursor/"User/workspaceStorage/workspace/state.json").write("{}")
    (cursor/"User/globalStorage").mkpath
    (cursor/"User/globalStorage/state.vscdb").write("cursor")
    (cursor/"logs").mkpath
    (cursor/"logs/cursor.log").write("cursor")

    (copilot/"session-state").mkpath
    (copilot/"session-state/session.json").write("{}")
    (copilot/"logs").mkpath
    (copilot/"logs/copilot.log").write("copilot")

    (opencode/"log").mkpath
    (opencode/"log/opencode.log").write("opencode")
    (opencode/"snapshot").mkpath
    (opencode/"snapshot/object").write("snapshot")
    (opencode/"opencode.db").write("opencode")

    state_home = home/"forbidden-state"
    ENV["XDG_STATE_HOME"] = state_home.to_s
    output = shell_output(
      "#{bin}/agentrinse audit --home #{home} " \
      "--providers cursor,copilot,opencode --no-state --json",
    )
    envelope = JSON.parse(output)
    assert_equal %w[
      agentrinseVersion command completedAt data diagnostics schemaVersion startedAt status
    ].sort, envelope.keys.sort
    assert_equal 1, envelope.fetch("schemaVersion")
    assert_equal "audit", envelope.fetch("command")
    assert_equal version.to_s, envelope.fetch("agentrinseVersion")
    assert_equal "ok", envelope.fetch("status")
    assert_empty envelope.fetch("diagnostics")

    report = envelope.fetch("data")
    assert_equal %w[
      auditId completedAt diagnostics findings home probes schemaVersion startedAt
    ].sort, report.keys.sort
    assert_equal 1, report.fetch("schemaVersion")
    assert_equal home.to_s, report.fetch("home")
    assert_empty report.fetch("diagnostics")
    assert_equal %w[copilot cursor opencode], report.fetch("probes").map { |probe| probe.fetch("adapter") }
    assert report.fetch("probes").all? { |probe| probe.fetch("status") == "available" }

    findings = report.fetch("findings")
    refute_empty findings
    assert_equal %w[copilot cursor opencode],
                 findings.map { |finding| finding.fetch("resource").fetch("adapter") }.uniq.sort
    assert findings.all? { |finding| finding.fetch("candidateActions").empty? }
    refute_path_exists state_home
  end
end
