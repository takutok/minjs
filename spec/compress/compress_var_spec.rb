# coding: utf-8
require 'spec_helper'

describe 'Compression' do
  describe 'CompressVar' do
    it 'compress var name' do
      c = test_compressor
      c.parse <<-EOS
function xxxx()
{
    var aaaa, bbbb;// => a,b
    function yyyy(){//=>c
	var cccc, dddd, a, b; // => a,b,d,e
    }
    function wwww(c, d){//=>d(a,b)
	var cccc, dddd, a, b; // => c,d,e,f
    }
    function eeee(c, d){//=>e(a,b)
	var aaaa, bbbb; // => c,d
    }
    function rrrr(c, d){//=>f(c,d)
	aaaa, bbbb; // => a,b
	function i(){
	}
	aaaa:while(true);
    }
}
EOS
      js = c.compress_var.to_js

      expect(js).to eq "function xxxx(){var a,b;function c(){var a,b,c,d}function d(a,b){var c,d,e,f}function e(a,b){var c,d}function f(c,d){a,b;function e(){}a:while(true);}}"
    end
    it 'compress try-catch var name' do
      c = test_compressor
      c.parse <<-EOS
function zzz(){
var aaaa;
try{
}
catch(aaaa){
var bbb;
console.log(aaaa);
}
finally{
}
}
EOS
      js = c.compress_var.to_js
      expect(js).to eq "function zzz(){var a;try{}catch(a){var b;console.log(a)}finally{}}"
    end

    it 'compress var name' do
      c = test_compressor
      c.parse <<-EOS
function x()
{
    var a;
    function b(xxx,yyy,zzz){
	var b;
    }
}
EOS
      js = c.compress_var.to_js
      expect(js).to eq "function x(){var b;function a(a,b,c){var d}}"
    end

    it 'compress var name' do
      c = test_compressor
      c.parse <<-EOS
function zz()
{
    var a = function b(){
	console.log(b);
    }
    console.log(b);
}
EOS
      js = c.compress_var.to_js
      expect(js).to eq "function zz(){var a=function a(){console.log(a)};console.log(b)}"
    end
  end
end

