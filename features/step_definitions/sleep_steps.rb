When "I sleep for {string} ms" do |n|
  sleep (n.to_f/1000)
end

When "I sleep for {string} ms" do |n|
  sleep n.to_i
end

