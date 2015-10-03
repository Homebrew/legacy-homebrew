require "formula"

module Homebrew
  SOURCE_PATH=HOMEBREW_REPOSITORY/"Library/Homebrew/manpages"
  TARGET_PATH=HOMEBREW_REPOSITORY/"share/man/man1"
  DOC_PATH=HOMEBREW_REPOSITORY/"share/doc/homebrew"
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

      puts "Writing HTML fragments to #{DOC_PATH}"
      puts "Writing manpages to #{TARGET_PATH}"

      target_file = nil
      Dir["#{SOURCE_PATH}/*.md"].each do |source_file|
        target_html = DOC_PATH/"#{File.basename(source_file, ".md")}.html"
        safe_system "ronn --fragment --pipe --organization='Homebrew' --manual='brew' #{source_file} > #{target_html}"
        target_man = TARGET_PATH/File.basename(source_file, ".md")
        safe_system "ronn --roff --pipe --organization='Homebrew' --manual='brew' #{source_file} > #{target_man}"
      end

      system "man", target_file if ARGV.flag? "--verbose"
    end
  end
end
