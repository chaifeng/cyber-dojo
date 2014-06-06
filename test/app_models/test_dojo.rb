#!/usr/bin/env ruby

require File.dirname(__FILE__) + '/model_test_case'

class DojoTests < ModelTestCase

  test "path is as set in ctor" do
    json_and_rb do
      assert_equal root_path, @dojo.path
    end
  end

  #- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  test "languages['xxx'] gives you language which knows its name is 'xxx'" do
    json_and_rb do
      assert_equal 'Ruby', @dojo.languages['Ruby'].name
      assert_equal 'C', @dojo.languages['C'].name
      assert_equal 'Erlang', @dojo.languages['Erlang'].name
    end
  end

  #- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  test "c'tor format determines kata's manifest format" do
    json_and_rb do |fmt|
      language = @dojo.languages['Java-JUnit']
      @paas.dir(language).spy_read2('manifest.json', {
        :unit_test_framework => 'JUnit'
      })
      exercise = @dojo.exercises['test_Yahtzee']
      @paas.dir(exercise).spy_read('instructions', 'your task...')
      kata = @dojo.make_kata(language, exercise)
      assert_equal 'manifest.'+fmt, kata.manifest_filename
      log = @paas.dir(kata).log
      assert filenames_written_to_in(log).include?('manifest.'+fmt)
    end
  end

end