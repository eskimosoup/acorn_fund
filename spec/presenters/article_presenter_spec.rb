require "rails_helper"

RSpec.describe ArticlePresenter, type: :presenter do
  let(:article) { build(:article) }
  subject(:article_presenter) { ArticlePresenter.new(object: article, view_template: view)}

  describe "delegations", :delegation do
    it { should delegate_method(:title).to(:article) }
  end

  describe "standard article" do
    it "returns the linked title" do
      expect(article_presenter.linked_title).to eq(link_to article.title, article, title: article.title)
    end

    it "returns the summary - html formatted" do
      expect(article_presenter.content).to eq(simple_format article.summary)
    end

    it "returns the content - html escaped" do
      expect(article_presenter.content).to eq(raw article.content)
    end

    describe "date formatting" do
      it "should return the date with default format" do
        expect(article_presenter.date).to eq(l article.date, format: :default)
      end

      it "should return the date with short format" do
        expect(article_presenter.date(:short)).to eq(l article.date, format: :short)
      end

      it "should return the date with long format" do
        expect(article_presenter.date(:long)).to eq(l article.date, format: :long)
      end
    end
  end

  describe "images" do
    describe "no image" do
      it "show_image should return nil" do
        expect(article_presenter.show_image).to eq(nil)
      end
      it "index_image should return nil" do
        expect(article_presenter.index_image).to eq(nil)
      end
      it "linked index_image should return nil" do
        expect(article_presenter.linked_index_image).to eq(nil)
      end
    end

    describe "has image" do
      let(:article) { build(:article_with_image) }
      subject(:article_presenter) { ArticlePresenter.new(object: article, view_template: view)}

      it "show_image should not return nil" do
        expect(article_presenter.show_image(alt: article.title)).to eq(image_tag(article.image.show, alt: article.title))
      end

      it "index image should not return nil" do
        expect(article_presenter.index_image(alt: article.title)).to eq(image_tag(article.image.index, alt: article.title))
      end

      it "linked index image should not return nil" do
        expect(article_presenter.linked_index_image).to eq(link_to image_tag(article.image.index, alt: article.title), article, title: article.title)
      end
    end
  end
end
