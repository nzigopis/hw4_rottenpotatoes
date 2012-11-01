# Add a declarative step here for populating the DB with movies.

Given /the following movies exist/ do |movies_table|
  movies_table.hashes.each do |movie|
    # each returned element will be a hash whose key is the table header.
    # you should arrange to add that movie to the database here.
    Movie.create!(:title => movie[:title], :rating => movie[:rating], :release_date => movie[:release_date])
  end
end

# Make sure that one string (regexp) occurs before or after another one
#   on the same page
Then /^the director of "([^"]*)" should be "([^"]*)"$/i do |m,d|
  Movie.find_by_title!(m).director.should == d
end

Then /I should see "(.*)" before "(.*)"/ do |e1, e2|
  #  ensure that that e1 occurs before e2.
  #  page.content  is the entire content of the page as a string.
  # assert page.body.match(/#{e1}.*#{e2}/m) != nil 
  assert page.body =~ /#{e1}.*#{e2}/m
end

# Make it easier to express checking or unchecking several boxes at once
#  "When I uncheck the following ratings: PG, G, R"
#  "When I check the following ratings: G"

When /I (un)?check the following ratings: (.*)/ do |uncheck, rating_list|
  # HINT: use String#split to split up the rating_list, then
  #   iterate over the ratings and reuse the "When I check..." or
  #   "When I uncheck..." steps in lines 89-95 of web_steps.rb
  rating_list.split(/\s*,\s*/).each do |field| 
    if uncheck == 'un' then
      uncheck('ratings_' + field)
    else
      check('ratings_' + field) 
    end
  end
end

Then /^I should see all of the movies$/ do
  rows = page.body.scan(/(<tr.*?>)/).length - 1
  assert rows == Movie.find(:all).length
end

