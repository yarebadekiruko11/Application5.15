# frozen_string_literal: true

require 'rails_helper'

describe '投稿のテスト' do
  let!(:list) { create(:list, title:'hoge',body:'body') }
  describe 'トップ画面のテスト' do
    before do
      visit top_path
    end
    context '表示の確認' do
      it 'トップ画面(top_path)に｢ここはTopページです｣が表示されているか' do
        expect(page).to have_content 'ここはTopページです'
      end
      it 'top_pathが"/top"であるか' do
        expect(current_page).to eq('/top')
      end
    end
  end

  describe '投稿画面のテスト' do
    before do
      visit new_list_path
    end
    context '表示の確認' do
      it 'new_list_pathが"/lists/new"であるか' do
        expect(current_page).to ep('/lists/new')
      end
      it '投稿ボタンが表示されているか' do
        expect(page).to have_button '投稿'
      end
    end
    context '投稿処理のテスト' do
      it '投稿後のリダイレクト先は正しいか' do
        fill_in 'list[title]', with: Faker::Lorem.characters(number:10)
        fill_in 'list[body]', with: Faker::Lorem.characters(number:30)
        click_button '投稿'
        expect(page).to have_current_path list_path(list.last)
      end
    end
  end

  describe '一覧画面のテスト' do
    before do
      visit lists_path
    end
    context '一覧表示とリンクの確認' do
      it '一覧表示画面に投稿されたものが表示されているか' do
        except(page).to have_content list.title
        except(page).to have_link list.title
      end
    end
  end

  describe '詳細画面のテスト' do
    before do
      visit list_path(list)
    end
    context '表示の確認' do
      it '削除リンクが存在しているか' do
        except(page).to have_link '削除'
      end
      it '編集リンクが存在しているか' do
        except(page).to have_link '編集'
      end
    end
    context 'リンクの遷移先の確認' do
      it 'リンクの遷移先は編集画面か' do
        edit_link = find_all('a')[3]
        edit_link.click
        except(current_path).to eq('/lists/' + list.id.to_s + '/edit')
      end
    end
  end
end
