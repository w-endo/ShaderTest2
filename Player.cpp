#include "Player.h"
#include "Engine/Input.h"
#include "Bullet.h"
#include "MiniOden.h"
#include "Engine/SceneManager.h"

//コンストラクタ
Player::Player(GameObject* parent)
    :GameObject(parent, "Player")
{
}

//デストラクタ
Player::~Player()
{
}

//初期化
void Player::Initialize()
{
    pFbx = new Fbx;
    pFbx->Load("Assets/torus.fbx");

    //transform_.scale_.x = 0.5f;
    //transform_.scale_.y = 0.5f;
    //transform_.scale_.z = 0.5f;


}

//更新
void Player::Update()
{
    transform_.rotate_.y++;

}

//描画
void Player::Draw()
{
    pFbx->Draw(transform_);
}

//開放
void Player::Release()
{
}