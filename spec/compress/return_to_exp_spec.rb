# coding: utf-8
require 'spec_helper'

describe 'Expression' do
  describe 'BlockToStatement' do
    it 'convert return statement to expression' do
      c = Minjs::Compressor.new
      c.parse <<-EOS
function zzz(a){
if(a == 1){
console.log('a')
return a+1;
}
}
zzz(a)
EOS
      js = c.return_to_exp.to_js
      expect(js).to eq "function zzz(a){if(a==1)return console.log(\"a\"),a+1}zzz(a);"
    end
  end
end
