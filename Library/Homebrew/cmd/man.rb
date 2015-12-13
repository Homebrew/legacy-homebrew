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

      Dir["#{SOURCE_PATH}/*.md"].each do |source_file|
        args = %W[
          --pipe
          --organization=Homebrew
          --manual=brew
          #{source_file}
        ]
        page = File.basename(source_file, ".md")

        target_html = DOC_PATH/"#{page}.html"
        target_html.atomic_write Utils.popen_read("ronn", "--fragment", *args)

        target_man = TARGET_PATH/page
        target_man.atomic_write Utils.popen_read("ronn", "--roff", *args)
      end
    end
  end
end
