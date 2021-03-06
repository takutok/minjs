module Minjs
  module ECMA262
    class EnvRecord
      attr_reader :binding
      attr_reader :options

      def initialize(options = {})
        @binding = {}
        @options = {}
      end

      def create_mutable_binding(n, d, options = {})
        if n.kind_of? IdentifierName
          n = n.val
        end
        @binding[n] = {:value => nil}
      end

      def set_mutable_binding(n, v, s, options = {})
        if n.kind_of? IdentifierName
          n = n.val
        end
        @binding[n][:value] = v
        @binding[n].merge!(options)
      end
    end

    class ExObject
      def initialize(options = {})
        @attr = options[:attr] || {}
        @prop = options[:prop] || {}
      end
    end

    class LexEnv
      attr_reader :record
      attr_reader :outer

      def initialize(options = {})
        @outer = options[:outer]
        @record = EnvRecord.new
      end

      def new_declarative_env(outer = nil)
        LexEnv.new(outer: (outer || self))
      end

      def debug
        STDERR.puts @record.binding
      end
    end

    class Context
      attr_accessor :lex_env
      attr_accessor :var_env
      attr_accessor :this_binding

      def initialize(options = {})
        @var_env = LexEnv.new(options)
        @lex_env = LexEnv.new(options)
        @this_binding = ExObject.new(
          {
            attr: {
              writable: true,
              enumerable: false,
              configurable: true
            }
          }
        )
      end

      def debug
        @var_env.debug
      end

      def inspect
        @var_env.record.binding.to_s
      end
    end
  end
end
