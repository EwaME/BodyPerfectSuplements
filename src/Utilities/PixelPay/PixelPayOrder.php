<?php

namespace Utilities\PixelPay;

use Utilities\Context;

class PixelPayOrder{

    private $_request;
    private $_apirurl;
    private $_body = array(
        "_key" => "",
        "_callback" => "",
        "_cancel" => "",
        "_complete" => "",
        "_order_id" => "",
        "_order_date" => "",
        "_order_content" => "",
        "_order_extras" => "",
        "_currency"=>"HNL",
        "_tax_amount"=> 0,
        "_shipping_amount" => 0,
        "_amount" => 0,
        "_first_name" => "",
        "_last_name" => "",
        "_email"=>"",
        "_address" => "",
        "_address_alt"=> "",
        "_zip" => "",
        "_city" => "",
        "_state" => "",
        "_country" => "",
        "json" => true
    );
    public function __construct()
    {
        $this->_body["_key"] = Context::getContextByKey("PIXELPAY_KEY");
        $this->_apirurl = (Context::getContextByKey("PIXELPAY_ENV") === "PRD") ?
            Context::getContextByKey("PIXELPAY_URL"):
            "https://pixelpay.app";

    }
}

?>
