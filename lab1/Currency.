<?php

namespace catalog\models\currency;

use catalog\models\product\Product;
use catalog\models\product\ProductQuery;
use Yii;

/**
 * This is the model class for table "{{%currency}}".
 *
 * @property int $id
 * @property string $type
 * @property float $rate
 *
 * @property Product[] $products
 */
class Currency extends \yii\db\ActiveRecord
{
    /** @var string  */
    const ORIGIN_PRICE = 'рубль';

    /** @var string  */
    const DOLLAR_PRICE = 'доллар';

    /** @var string  */
    const EURO_PRICE = 'евро';

    /**
     * {@inheritdoc}
     */
    public static function tableName()
    {
        return '{{%currency}}';
    }

    /**
     * {@inheritdoc}
     */
    public function rules()
    {
        return [
            [['type', 'rate'], 'required'],
            [['rate'], 'number'],
            [['type'], 'string', 'max' => 255],
        ];
    }

    /**
     * {@inheritdoc}
     */
    public function attributeLabels()
    {
        return [
            'id' => Yii::t('app', 'ID'),
            'type' => Yii::t('app', 'Type'),
            'rate' => Yii::t('app', 'Rate'),
        ];
    }

    /**
     * Gets query for [[Products]].
     *
     * @return \yii\db\ActiveQuery|ProductQuery
     */
    public function getProducts()
    {
        return $this->hasMany(Product::className(), ['currency_id' => 'id']);
    }

    /**
     * {@inheritdoc}
     * @return CurrencyQuery the active query used by this AR class.
     */
    public static function find()
    {
        return new CurrencyQuery(get_called_class());
    }
}
