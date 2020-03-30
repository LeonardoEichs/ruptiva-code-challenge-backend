# frozen_string_literal: true

require 'rails_helper'

RSpec.describe User, type: :model do
  it 'is valid with valid attributes' do
    expect(User.new(first_name: 'Teste', last_name: 'Teste', email: 'test@test.com', password: 'password', password_confirmation: 'password')).to be_valid
  end

  it 'is not valid without a first_name' do
    expect(User.new(first_name: nil, last_name: 'Teste', email: 'test@test.com', password: 'password', password_confirmation: 'password')).to_not be_valid
  end

  it 'is not valid without a last_name' do
    expect(User.new(first_name: 'Teste', last_name: nil, email: 'test@test.com', password: 'password', password_confirmation: 'password')).to_not be_valid
  end

  it 'is not valid without a email' do
    expect(User.new(first_name: 'Teste', last_name: 'Teste', email: nil, password: 'password', password_confirmation: 'password')).to_not be_valid
  end

  it 'is not valid without a password' do
    expect(User.new(first_name: 'Teste', last_name: 'Teste', email: 'test@test.com', password: nil, password_confirmation: 'password')).to_not be_valid
  end

  it 'is user by default' do
    user = User.new(first_name: 'Teste', last_name: 'Teste', email: 'test@test.com', password: 'password', password_confirmation: 'password')
    expect(user.role == 'user')
  end

  it 'is admin' do
    user = User.new(first_name: 'Teste', last_name: 'Teste', email: 'test@test.com', password: 'password', password_confirmation: 'password', role: 'admin')
    expect(user.role == 'admin')
  end

  it 'is not valid without password confirmation' do
    expect(User.new(first_name: 'Teste', last_name: 'Teste', email: 'test@test.com', password: 'password')).to_not be_valid
  end

  it 'is not valid with wrong password confirmation' do
    expect(User.new(first_name: 'Teste', last_name: 'Teste', email: 'test@test.com', password: 'password', password_confirmation: '12345')).to_not be_valid
  end
end
