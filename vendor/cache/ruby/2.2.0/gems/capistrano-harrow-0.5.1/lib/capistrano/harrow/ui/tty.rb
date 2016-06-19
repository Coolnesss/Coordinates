module Capistrano
  module Harrow
    module UI
      class TTY
        def initialize(params={input: $stdin, output: $stdout, timeout: 30})
          @in = params.fetch(:input, $stdin)
          @out = params.fetch(:output, $stdout)
          @timeout = params.fetch(:timeout, 60)
        end

        def show(text)
          @out.puts text
        end

        def prompt_password(prompt_str)
          `stty -echo 2>/dev/null`
          password =  prompt(prompt_str, [])
          show "\n"
          password
        ensure
          `stty echo  2>/dev/null`
        end

        def prompt(prompt_str, answers=['yes', 'no'])
          answers = Array(answers)

          @out.write prompt_str

          default_answer = answers.first
          hints = answers_hint(answers)

          unless hints.empty?
            @out.write " "
            @out.write hints
          end

          @out.write ": "

          unless IO.select([@in], [], [], @timeout)
            raise TimeoutError.new
          else
            answer = @in.gets.chop
          end

          return default_answer if answer.empty?

          answer
        end

        private
        def answers_hint(answers)
          return '' if Array(answers).length == 0
          items = answers.map(&:to_s).map(&:strip)
          items[0] = items.first[0].upcase + items.first[1..-1]
          "(#{items.join("/")})"
        end
      end
    end
  end
end
