# typed: false
# frozen_string_literal: true

# Homebrew formula for Natilius
# To use: brew tap vincentkoc/tap && brew install natilius
# Or: brew install vincentkoc/tap/natilius

class Natilius < Formula
  desc "Automated one-click Mac developer environment setup"
  homepage "https://github.com/vincentkoc/natilius"
  url "https://github.com/vincentkoc/natilius/archive/refs/tags/v1.4.3.tar.gz"
  sha256 "b4288c5189189cda0fed1ad6838d79a009514274aa0618659da53c13f18227c9"
  license "GPL-3.0-or-later"
  head "https://github.com/vincentkoc/natilius.git", branch: "main"

  def install
    # Install main script to libexec
    libexec.install "natilius.sh"

    # Install library files
    (libexec/"lib").install Dir["lib/*.sh"]

    # Install modules
    (libexec/"modules").install Dir["modules/*"]

    # Install profiles
    (libexec/"profiles").install Dir["profiles/*"]

    # Install completions
    bash_completion.install "completions/natilius-completion.bash" => "natilius"
    zsh_completion.install "completions/natilius-completion.zsh" => "_natilius"

    # Install example config
    (share/"natilius").install ".natiliusrc.example"

    # Create wrapper script that sets NATILIUS_HOME
    (bin/"natilius").write <<~EOS
      #!/bin/bash
      export NATILIUS_HOME="#{libexec}"
      exec "#{libexec}/natilius.sh" "$@"
    EOS
    (bin/"natilius").chmod 0755
  end

  def post_install
    user_config = "#{ENV["HOME"]}/.natiliusrc"
    unless File.exist?(user_config)
      ohai "Creating default config at ~/.natiliusrc"
      cp "#{share}/natilius/.natiliusrc.example", user_config
    end
  end

  def caveats
    <<~EOS
      To get started with Natilius:

        natilius --help        # Show available commands
        natilius doctor        # Check system readiness
        natilius --check       # Dry run (preview changes)
        natilius setup         # Run full setup

      Configuration file: ~/.natiliusrc
      Edit this file to customize which modules and packages to install.

      Available profiles:
        natilius --profile minimal   # Quick setup, essentials only
        natilius --profile devops    # Kubernetes, Terraform, cloud tools
        natilius --profile developer # Full dev environment
        natilius --profile clawdbot  # AI agent (moltbot) with Mackup restore
    EOS
  end

  test do
    assert_match "Natilius", shell_output("#{bin}/natilius version")
  end
end
