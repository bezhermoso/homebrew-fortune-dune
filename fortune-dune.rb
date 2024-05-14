require "erb"
require "shellwords"

# Documentation: https://docs.brew.sh/Formula-Cookbook
#                https://rubydoc.brew.sh/Formula
# PLEASE REMOVE ALL GENERATED COMMENTS BEFORE SUBMITTING YOUR PULL REQUEST!
class FortuneDune < Formula
  desc "Fortune files with quotes from Dune. (Sourced from an old RPM for Red Hat Linux)"
  homepage ""
  url "https://rpmfind.net/linux/dag/redhat/el6/en/x86_64/dag/RPMS/fortune-dune-1.0-37.2.el6.rf.x86_64.rpm"
  sha256 "d8e9ee16ec6c4beeb12e0d5e0cce23198bfee8563d78f913e3525754d84c3ec9"
  license ""

  uses_from_macos "tar"
  depends_on "fortune"

  resource "rpm" do
  end

  def install
    dune_fortunes_dir_path.mkpath
    # Extract the RPM contents. Homebrew does not automatically untar RPMs.
    system "tar", "-xf", "./fortune-dune-1.0-37.2.el6.rf.x86_64.rpm"
    dune_fortunes_dir_path.install Dir.glob("./usr/share/games/fortune/*")

    File.open(install_script_path, "w") do |f|
      f.write(install_script)
    end
    chmod 0755, install_script_path

    File.open(uninstall_script_path, "w") do |f|
      f.write(uninstall_script)
    end
    chmod 0755, uninstall_script_path
  end

  def dune_fortunes_dir_path
    prefix/"fortunes"
  end

  def system_fortunes_dir_path
    Formula["fortune"].prefix/"share/games/fortunes"
  end

  def install_script_path
    prefix/"install.sh"
  end

  def install_script
    return ERB.new(<<~BLOCK).result(binding)
    #!/usr/bin/env zsh
    <% Dir.glob(dune_fortunes_dir_path/"*").each do |f| %>
    echo "Symlinking: "<%= Shellwords.escape(f) %>
    ln -sf <%= Shellwords.escape(f) %> <%= Shellwords.escape(system_fortunes_dir_path) %>
    <% end %>
    BLOCK
  end

  def uninstall_script_path
    prefix/"uninstall.sh"
  end

  def uninstall_script
    return ERB.new(<<~BLOCK).result(binding)
    #!/usr/bin/env bash
    <% Dir.glob(dune_fortunes_dir_path/"*").each do |f| %>
    echo "Removing: "<%= Shellwords.escape(f) %>
    rm <%= Shellwords.escape(f) %>
    <% end %>
    BLOCK
  end

  def caveats
    <<~EOS

    To start seeing Dune quotes from `fortune`, install the fortune files to #{system_fortunes_dir_path} by running:

      # Zsh/Bash:
      #{install_script_path}

    EOS
  end

  # test do
  #   # `test do` will create, run in and delete a temporary directory.
  #   #
  #   # This test will fail and we won't accept that! For Homebrew/homebrew-core
  #   # this will need to be a test that verifies the functionality of the
  #   # software. Run the test with `brew test fortune-dune`. Options passed
  #   # to `brew install` such as `--HEAD` also need to be provided to `brew test`.
  #   #
  #   # The installed folder is not in the path, so use the entire path to any
  #   # executables being tested: `system "#{bin}/program", "do", "something"`.
  #   system "false"
  # end
end
