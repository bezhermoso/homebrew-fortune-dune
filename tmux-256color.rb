# Documentation: https://docs.brew.sh/Formula-Cookbook
#                https://rubydoc.brew.sh/Formula
# PLEASE REMOVE ALL GENERATED COMMENTS BEFORE SUBMITTING YOUR PULL REQUEST!
class Tmux256color < Formula
  desc ""
  homepage ""
  url "https://raw.githubusercontent.com/bezhermoso/homebrew-taps/main/tmux-256color/Makefile"
  version "latest"
  sha256 "ad9a767c84ab32001494395ed07903c951174b1b13a42360c9cad58b8c460004"
  license ""

  depends_on "ncurses"

  def install
    # Remove unrecognized options if they cause configure to fail
    # https://rubydoc.brew.sh/Formula.html#std_configure_args-instance_method
    # system "cmake", "-S", ".", "-B", "build", *std_cmake_args

    system "make", "install", "ncurses_path=#{ncurses_path}"
    prefix.install "terminfo"
  end

  def ncurses_path
    Formula["ncurses"].prefix
  end

  def caveats
    <<~EOS
    
    Add #{prefix}/terminfo in your TERMINFO_DIRS environment variable e.g.

    # ~/.zshrc or ~/.bashrc

    TERMINFO_DIRS="#{prefix}/terminfo:${TERMINFO_DIRS}"

    EOS
  end

  test do
    # `test do` will create, run in and delete a temporary directory.
    #
    # This test will fail and we won't accept that! For Homebrew/homebrew-core
    # this will need to be a test that verifies the functionality of the
    # software. Run the test with `brew test tmux-256color`. Options passed
    # to `brew install` such as `--HEAD` also need to be provided to `brew test`.
    #
    # The installed folder is not in the path, so use the entire path to any
    # executables being tested: `system "#{bin}/program", "do", "something"`.
    system "false"
  end
end
