class Pathname
  def cp(dst)
    opoo "Pathname#cp is deprecated, use FileUtils.cp"
    if file?
      FileUtils.cp to_s, dst
    else
      FileUtils.cp_r to_s, dst
    end
    dst
  end

  def chmod_R(perms)
    opoo "Pathname#chmod_R is deprecated, use FileUtils.chmod_R"
    require "fileutils"
    FileUtils.chmod_R perms, to_s
  end
end
