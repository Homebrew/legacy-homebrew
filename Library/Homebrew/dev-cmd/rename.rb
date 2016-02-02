require "formulary"
require "tap"

module Homebrew
  def rename
    raise "There should be exactly two arguments passed." if ARGV.named.size != 2

    src = ARGV.named.first
    dst = ARGV.named.last

    if src.include?("/") && dst.include?("/")
      src_user, src_repo, src_name = src.split("/")
      dst_user, dst_repo, dst_name = dst.split("/")
      unless "#{src_user}/#{src_repo}" == "#{dst_user}/#{dst_repo}"
        raise "Both names should be from the same tap."
      end
    elsif src.include?("/")
      user, repo, src = src.split("/")
    end

    user = src_user || user || "homebrew"
    repo = src_repo || repo || "homebrew"
    src = src_name || src
    dst = dst_name || dst
    tap = Tap.fetch(user, repo)

    raise "Given tap is not a git repository." unless tap.git?

    formula_path = tap.formula_dir.join("#{src}.rb")
    new_formula_path = tap.formula_dir.join("#{dst}.rb")

    raise "There is no formula #{src}." unless formula_path.file?
    raise "#{dst} already exists." if new_formula_path.exist?

    formula_path.rename(new_formula_path)

    file_contents = File.read(new_formula_path)
    new_file_contents = file_contents.gsub(/#{Formulary.class_s(src)} < Formula/,\
                                           "#{Formulary.class_s(dst)} < Formula")
    File.write(new_formula_path, new_file_contents)

    tap.formula_renames_dir.mkdir unless tap.formula_renames_dir.exist?

    File.open(tap.formula_renames_dir.join(src), "a+") do |file|
      file.write("#{dst}, #{Utils.popen_read("git", "rev-parse", "origin/master")}")
    end
  end
end
