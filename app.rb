require 'sinatra'
require 'prime'
require 'chunky_png'

get '/' do
  unless params[:width] && params[:height]
    return "Error, you must specify a width and height"
  end
  width = params[:width].to_i
  height = params[:height].to_i
  start_at = 2
  start_at ||= params[:start].to_i
  col_major = !!params[:col_major]

  content_type 'image/png'

  img = ChunkyPNG::Image.new(width, height, ChunkyPNG::Color('black'))
  for x in 0...width
    for y in 0...height
      if Prime.prime?(start_at + (col_major ? y*width+x : x * height + y))
        img[x,y] = ChunkyPNG::Color(0,255,0)
      end
    end
  end

  stream do |out|
    out << img.to_blob
  end
end
