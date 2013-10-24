module HomebrewEnvExtension
  def use_clang?
    compiler == :clang
  end

  def use_gcc?
    compiler == :gcc
  end

  def use_llvm?
    compiler == :llvm
  end
end
