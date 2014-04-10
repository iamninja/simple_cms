require 'sinatra'
require 'mongoid'
require 'slim'
require "redcarpet"

configure do
	Mongoid.load!("./mongoid.yml")
end

class Page
	include Mongoid::Document

	field :title, 		type: String
	field :content, 	type: String
end

get '/pages' do
	@pages = Page.all
	@title = "Simple CMS: Page List"
	slim :index
end

post '/pages' do
	page = Page.create(params[:page])
	redirect to("/pages/#{page.id}")
end

get '/pages/:id' do
	@page = Page.find(params[:id])
	@title = @page.title
	slim :show
end

put '/pages/:id' do
  page = Page.find(params[:id])
  page.update_attributes(params[:page])
  redirect to("/pages/#{page.id}")
end

delete '/pages/:id' do
  Page.find(params[:id]).destroy
  redirect to('/pages')
end

get '/pages/:id/edit' do
  @page = Page.find(params[:id])
  slim :edit
end

get '/pages/delete/:id' do
  @page = Page.find(params[:id])
  slim :delete
end

get '/new' do
	@page = Page.new
	slim :new
end