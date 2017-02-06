class LyraPhase
  module Helpers
    def has_formula_named?(arr, formula_name)
      arr.flat_map{ |elem|
        elem.include?(formula_name) || (elem.kind_of?(Hash) && elem.keys.any? {|k| elem[k].include?(formula_name)})
      }.any?{ |elem| elem == true }
    end
  end
end

Chef::Recipe.send(:include, LyraPhase::Helpers)
