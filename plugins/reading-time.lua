-- Makes a reading time estimate based on word count.
--
-- Sample configuration:
-- [plugins.reading_]
--   active_link_class = "active"
--   selector = "nav"
--
-- Minimal soupault version: 1.6
-- Author: Daniil Baturin
-- License: MIT

reading_speed = config["reading_speed"]
selector = config["selector"]
content_selector = config["content_selector"]

if (not reading_speed) then
  Log.warning("Missing option \"reading_speed\", using default (300 WPM)")
  reading_speed = 300
end

if (not selector) then
  Log.warning("Missing option \"selector\", using default (body)")
  selector = "body"
end

if (not content_selector) then
  Log.warning("Missing option \"content_selector\", using default (body)")
  content_selector = "body"
end

-- Extract the content
content_element = HTML.select_one(page, content_selector)
content = HTML.strip_tags(content_element)

-- Calculate the word count
words = Regex.split(content, "\\s+")
word_count = size(words)

-- Make a reading time text
reading_time = floor(word_count / reading_speed)

if (reading_time <= 1) then
  time_msg = "less than a minute"
else
  time_msg = reading_time .. " minutes"
end

-- Insert the text in the target element
target = HTML.select_one(page, selector)
if target then
  HTML.prepend_child(target, HTML.create_text(time_msg))
end