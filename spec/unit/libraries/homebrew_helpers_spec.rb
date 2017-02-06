require 'spec_helper'

describe LyraPhase do
  # Create a dummy class to include helper method: has_formula_named?
  let(:dummy_class) { Class.new { include LyraPhase::Helpers } }

  context 'when formulas Array contains the formula string' do
    describe "#has_formula_named?" do
      let(:formulas) { [  'foo', 'bar', 'baz',
                          {'name' => 'hashformula', 'options' => '--HEAD'}
                        ]
                      }
      let(:expected_formula_names) { ['foo', 'bar', 'baz', 'hashformula'] }

      it "returns true" do
        expected_formula_names.each do |expected_formula|
          expect(dummy_class.new.has_formula_named?(formulas, expected_formula)).to be true
        end
      end

    end
  end

  context 'when formulas Array DOES NOT contain the formula string' do
    describe "#has_formula_named?" do
      let(:formulas) { [  'a', 'b', 'c',
                          {'name' => 'something', 'options' => '--HEAD'}
                        ]
                      }
      let(:expected_formula_names) { ['these', 'do', 'not', 'exist'] }

      it "returns false" do
        expected_formula_names.each do |expected_formula|
          expect(dummy_class.new.has_formula_named?(formulas, expected_formula)).to be false
        end
      end
    end
  end

end
