class Admin::BooksController < ApplicationController
  http_basic_authenticate_with name: Rails.application.credentials.admin_username!,
                               password: Rails.application.credentials.admin_password!

  def index
    @books = Book.order(:title)
  end

  def update
    @book = Book.find(params[:id])
    if @book.update(book_params)
      respond_to do |format|
        format.turbo_stream { head :ok }
        format.html { redirect_to admin_books_path }
      end
    else
      head :unprocessable_entity
    end
  end

  private

  def book_params
    params.require(:book).permit(:display_title, :display_author)
  end
end
