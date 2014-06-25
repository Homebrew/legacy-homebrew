require 'formula'
require 'ostruct'

module Homebrew
  def deps
    mode = OpenStruct.new(
      :installed?  => ARGV.include?('--installed'),
      :tree?       => ARGV.include?('--tree'),
      :all?        => ARGV.include?('--all'),
      :topo_order? => ARGV.include?('-n'),
      :union?      => ARGV.include?('--union')
    )

    if mode.installed? && mode.tree?
      puts_deps_tree Formula.installed
    elsif mode.installed?
      puts_deps Formula.installed
    elsif mode.all?
      puts_deps Formula
    elsif mode.tree?
      raise FormulaUnspecifiedError if ARGV.named.empty?
      puts_deps_tree ARGV.formulae
    else
      raise FormulaUnspecifiedError if ARGV.named.empty?
      all_deps = deps_for_formulae(ARGV.formulae, !ARGV.one?, &(mode.union? ? :| : :&))
      all_deps = all_deps.sort_by(&:name) unless mode.topo_order?
      puts all_deps
    end
  end

  def deps_for_formula(f, recursive=false)
    if recursive
      deps = f.recursive_dependencies
      reqs = f.recursive_requirements
    else
      deps = f.deps.default
      reqs = f.requirements
    end

    deps + reqs.select(&:default_formula?).map(&:to_dependency)
  end

  def deps_for_formulae(formulae, recursive=false, &block)
    formulae.map {|f| deps_for_formula(f, recursive) }.inject(&block)
  end

  def puts_deps(formulae)
    formulae.each { |f| puts "#{f.name}: #{deps_for_formula(f).sort_by(&:name) * " "}" }
  end

  def puts_deps_tree(formulae)
    formulae.each do |f|
      puts f.name
      recursive_deps_tree(f, 1)
      puts
    end
  end

  def recursive_deps_tree f, level
    f.requirements.select(&:default_formula?).each do |req|
      puts "|  "*(level-1) + "|- :#{req.to_dependency.name}"
    end
    f.deps.default.each do |dep|
      puts "|  "*(level-1) + "|- #{dep.name}"
      recursive_deps_tree(Formulary.factory(dep.name), level+1)
    end
  end
end
