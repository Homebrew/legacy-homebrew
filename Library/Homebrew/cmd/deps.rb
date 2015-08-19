# encoding: UTF-8
require "formula"
require "ostruct"

module Homebrew
  def deps
    mode = OpenStruct.new(
      :installed?  => ARGV.include?("--installed"),
      :tree?       => ARGV.include?("--tree"),
      :all?        => ARGV.include?("--all"),
      :topo_order? => ARGV.include?("-n"),
      :union?      => ARGV.include?("--union")
    )

    if mode.installed? && mode.tree?
      puts_deps_tree Formula.installed
    elsif mode.all?
      puts_deps Formula
    elsif mode.tree?
      raise FormulaUnspecifiedError if ARGV.named.empty?
      puts_deps_tree ARGV.formulae
    elsif ARGV.named.empty?
      raise FormulaUnspecifiedError unless mode.installed?
      puts_deps Formula.installed
    else
      all_deps = deps_for_formulae(ARGV.formulae, !ARGV.one?, &(mode.union? ? :| : :&))
      all_deps = all_deps.select(&:installed?) if mode.installed?
      all_deps = all_deps.sort_by(&:name) unless mode.topo_order?
      puts all_deps
    end
  end

  def deps_for_formula(f, recursive = false)
    ignores = []
    ignores << "build?" if ARGV.include? "--skip-build"
    ignores << "optional?" if ARGV.include? "--skip-optional"

    if recursive
      deps = f.recursive_dependencies do |dependent, dep|
        Dependency.prune if ignores.any? { |ignore| dep.send(ignore) } && !dependent.build.with?(dep)
      end
      reqs = f.recursive_requirements do |dependent, req|
        Requirement.prune if ignores.any? { |ignore| req.send(ignore) } && !dependent.build.with?(req)
      end
    else
      deps = f.deps.reject do |dep|
        ignores.any? { |ignore| dep.send(ignore) }
      end
      reqs = f.requirements.reject do |req|
        ignores.any? { |ignore| req.send(ignore) }
      end
    end

    deps + reqs.select(&:default_formula?).map(&:to_dependency)
  end

  def deps_for_formulae(formulae, recursive = false, &block)
    formulae.map { |f| deps_for_formula(f, recursive) }.inject(&block)
  end

  def puts_deps(formulae)
    formulae.each { |f| puts "#{f.full_name}: #{deps_for_formula(f).sort_by(&:name) * " "}" }
  end

  def puts_deps_tree(formulae)
    formulae.each do |f|
      puts "#{f.full_name} (required dependencies)"
      recursive_deps_tree(f, "")
      puts
    end
  end

  def recursive_deps_tree(f, prefix)
    reqs = f.requirements.select(&:default_formula?)
    max = reqs.length - 1
    reqs.each_with_index do |req, i|
      chr = i == max ? "└──" : "├──"
      puts prefix + "#{chr} :#{req.to_dependency.name}"
    end
    deps = f.deps.default
    max = deps.length - 1
    deps.each_with_index do |dep, i|
      chr = i == max ? "└──" : "├──"
      prefix_ext = i == max ? "    " : "|   "
      puts prefix + "#{chr} #{dep.name}"
      recursive_deps_tree(Formulary.factory(dep.name), prefix + prefix_ext)
    end
  end
end
