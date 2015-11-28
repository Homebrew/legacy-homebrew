class CudaRequirement < Requirement
  fatal true
  cask "cuda"

  def initialize(tags)
    @version = tags.shift if /\d+\.*\d*/ === tags.first
    super
  end

  satisfy :build_env => false do
    next false unless which "nvcc"
    next true unless @version
    cuda_version = /\d\.\d/.match Utils.popen_read("nvcc", "-V")
    Version.new(cuda_version.to_s) >= Version.new(@version)
  end

  env do
    nvccdir = which("nvcc").dirname
    ENV.prepend_path "PATH", nvccdir
    ENV.prepend_create_path "DYLD_LIBRARY_PATH", nvccdir.parent/"lib"
    ENV["CUDACC"] = "nvcc"
  end

  def message
    if @version
      s = "CUDA #{@version} or later is required."
    else
      s = "CUDA is required."
    end
    s += super
    s
  end

  def inspect
    "#<#{self.class.name}: #{name.inspect} #{tags.inspect} version=#{@version.inspect}>"
  end
end
