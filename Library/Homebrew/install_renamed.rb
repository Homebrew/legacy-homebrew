module InstallRenamed
  def install_p src, new_basename = nil
    super do |src, dst|
      dst += "/#{File.basename(src)}" if File.directory? dst
      append_default_if_different(src, dst)
    end
  end

  private

  def append_default_if_different src, dst
    if File.file? dst and !FileUtils.identical?(src, dst) and !HOMEBREW_GIT_ETC
      dst += ".default"
    end
    dst
  end
end
