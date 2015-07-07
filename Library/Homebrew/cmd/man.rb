require 'formula'

module Homebrew
  SOURCE_PATH=HOMEBREW_REPOSITORY/"Library/Homebrew/manpages"
  TARGET_PATH=HOMEBREW_REPOSITORY/"share/man/man1"
  LINKED_PATH=HOMEBREW_PREFIX/"share/man/man1"

  def man
    abort <<-EOS.undent unless ARGV.named.empty?
      This command updates the brew manpage and does not take formula names.
    EOS

    if ARGV.flag? "--link"
      abort <<-EOS.undent if TARGET_PATH == LINKED_PATH
        The target path is the same as the linked one, aborting.
      EOS
      Dir["#{TARGET_PATH}/*.1"].each do |page|
        FileUtils.ln_s page, LINKED_PATH
        return
      end
    else
      Homebrew.install_gem_setup_path! "ronn"

      puts "Writing manpages to #{TARGET_PATH}"

      target_file = nil
      Dir["#{SOURCE_PATH}/*.md"].each do |source_file|
        target_file = TARGET_PATH/File.basename(source_file, ".md")
        safe_system "ronn --roff --pipe --organization='Homebrew' --manual='brew' #{source_file} > #{target_file}"
      end

      system "man", target_file if ARGV.flag? "--verbose"
    end
  end
end
