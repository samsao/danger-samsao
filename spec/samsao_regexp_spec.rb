require File.expand_path('../spec_helper', __FILE__)

require 'samsao/regexp'

module Samsao
  describe Samsao::Regexp do
    describe '#from_sources' do
      it 'returns regexp with prefixed with ^ when string' do
        expect(Samsao::Regexp.from_source('src')).to eq(/^src/)
      end

      it 'returns regexp as-is on regexp' do
        expect(Samsao::Regexp.from_source(/[abc]*/)).to eq(/[abc]*/)
      end
    end

    describe '#from_matcher' do
      it 'returns quoted string on string' do
        expect(Samsao::Regexp.from_matcher('.*')).to eq(/\.\*/)
      end

      it 'returns as-is on regexp' do
        expect(Samsao::Regexp.from_matcher(/.*/)).to eq(/.*/)
      end

      it 'supports string regexp modifier' do
        expect(Samsao::Regexp.from_matcher('common/src', when_string_pattern_prefix_with: '^')).to eq(%r{^common/src})
      end

      it 'discards string regexp modifier when mathcer is a regexp' do
        expect(Samsao::Regexp.from_matcher(/.*/, when_string_pattern_prefix_with: '^')).to eq(/.*/)
      end
    end
  end
end
