# coding: utf-8
require 'spec_helper'

describe 'Compression' do
  describe 'SimpleReplacement' do
    it 'replacement' do
      c = test_compressor
      c.parse <<-EOS
true;
false;
if(1)a;
if(0)a;
if(0)a;else b;
while(1);
EOS
      js = c.simple_replacement.to_js
      expect(js).to eq "(!0);(!1);a;b;for(;;);"
    end
    it 'replacement' do
      c = test_compressor
      c.parse <<-EOS
if(a);
if(b){}
if(c);else;
if(d){}else{}
if(e)aa;else;
if(f)bb;else{}
if(g)
  if(h)
    hh;
  else
    ;
else
  gg;
EOS
      js = c.simple_replacement.to_js
      expect(js).to eq "a;b;c;d;if(e)aa;if(f)bb;if(g){if(h)hh}else gg;"
    end
  end
end

