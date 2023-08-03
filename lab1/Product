<?php

namespace catalog\models\product;

use catalog\models\currency\Currency;
use catalog\modules\promocode\models\Promocode;
use lhs\Yii2SaveRelationsBehavior\SaveRelationsBehavior;
use Yii;
use yii\db\ActiveRecord;

/**
 * This is the model class for table "{{%products}}".
 *
 * @property int $id
 * @property string $name
 * @property string|null $slug
 * @property float|null $price
 * @property float|null $old_price
 * @property int|null $currency_id
 * @property int|null $status
 * @property int $promocode_id
 * @property boolean $promo_status
 * @property int $created_at
 * @property int $updated_at
 *
 * @property Currency $currency
 * @property Promocode $promocode
 */
class Product extends \yii\db\ActiveRecord
{
    /** @var int Статус черновика */
    const STATUS_DRAFT = 0;

    /** @var int Статус активного продукта */
    const STATUS_ACTIVE = 1;

    /** @var int Промокод не применен */
    const PROMO_NOT_APPLY = 0;

    /** @var int Промокод применен */
    const PROMO_APPLY = 1;

    /**
     * {@inheritdoc}
     */
    public static function tableName()
    {
        return '{{%products}}';
    }

    /**
     * {@inheritdoc}
     */
    public function behaviors()
    {
        return [
            'timestamp'     => [
                'class'      => 'yii\behaviors\TimestampBehavior',
                'attributes' => [
                    ActiveRecord::EVENT_BEFORE_INSERT => ['created_at', 'updated_at'],
                    ActiveRecord::EVENT_BEFORE_UPDATE => ['updated_at'],
                ],
            ],
            'slug'          => [
                'class'                => 'Zelenin\yii\behaviors\Slug',
                'slugAttribute'        => 'slug',
                'attribute'            => 'name',
                // optional params
                'ensureUnique'         => true,
                'replacement'          => '-',
                'lowercase'            => true,
                'immutable'            => false,
                // If intl extension is enabled, see http://userguide.icu-project.org/transforms/general.
                'transliterateOptions' => 'Russian-Latin/BGN; Any-Latin; Latin-ASCII; NFD; [:Nonspacing Mark:] Remove; NFC;'
            ],
            'saveRelations' => [
                'class'     => SaveRelationsBehavior::class,
                'relations' => [
//                    'price',
                ],
            ],
        ];
    }

    /**
     * {@inheritdoc}
     */
    public function attributeLabels()
    {
        return [
            'id'           => Yii::t('app', 'ID'),
            'name'         => Yii::t('app', 'Name'),
            'slug'         => Yii::t('app', 'Slug'),
            'price'        => Yii::t('app', 'Price'),
            'old_price'    => Yii::t('app', 'Old Price'),
            'currency_id'  => Yii::t('app', 'Currency ID'),
            'status'       => Yii::t('app', 'Status'),
            'promocode_id' => Yii::t('app', 'Promocode'),
            'promo_status' => Yii::t('app', 'Promo Status'),
            'created_at'   => Yii::t('app', 'Created At'),
            'updated_at'   => Yii::t('app', 'Updated At'),
        ];
    }

    /**
     * @param $name
     * @param $slug
     * @param $price
     * @param $currencyId
     * @param $promocodeId
     * @return static
     */
    public static function create($name, $slug, $price, $promocodeId): self
    {
        $product = new self();
        $product->name = $name;
        $product->slug = $slug;
        $product->price = $price;
        $product->status = self::STATUS_DRAFT;
        $product->promocode_id = $promocodeId;
        return $product;
    }

    /**
     * @param $name
     * @param $slug
     * @param $price
     * @param $currencyId
     * @param $promocodeId
     */
    public function edit($name, $slug, $price, $promocodeId): void
    {
        $this->name = $name;
        $this->slug = $slug;
        $this->price = $price;
        $this->promocode_id = $promocodeId;
    }

    /**
     * Gets query for [[Currency]].
     *
     * @return \yii\db\ActiveQuery
     */
    public function getCurrency()
    {
        return $this->hasOne(Currency::class, ['id' => 'currency_id']);
    }

    /**
     * @return \yii\db\ActiveQuery
     */
    public function getPromocode()
    {
        return $this->hasOne(Promocode::class, ['id' => 'promocode_id']);
    }

    /**
     * @return array
     */
    public function transactions()
    {
        return [
            self::SCENARIO_DEFAULT => self::OP_ALL,
        ];
    }
}
