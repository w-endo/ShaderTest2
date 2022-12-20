#include "Player.h"
#include "Engine/Input.h"
#include "Bullet.h"
#include "MiniOden.h"
#include "Engine/SceneManager.h"

//�R���X�g���N�^
Player::Player(GameObject* parent)
    :GameObject(parent, "Player")
{
}

//�f�X�g���N�^
Player::~Player()
{
}

//������
void Player::Initialize()
{
    pFbx = new Fbx;
    pFbx->Load("Assets/Water.fbx");

    transform_.scale_.x = 2.0f;
    transform_.scale_.y = 2.0f;
    transform_.scale_.z = 2.0f;


}

//�X�V
void Player::Update()
{
    //transform_.rotate_.y++;

}

//�`��
void Player::Draw()
{
    pFbx->Draw(transform_);
}

//�J��
void Player::Release()
{
}