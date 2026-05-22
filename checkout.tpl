<script>
    // Define state tab index value
    var statesTab = 10;
    // Do not enforce state input client side
    var stateNotRequired = true;
</script>
{include file="orderforms/standard_cart/common.tpl"}
<script type="text/javascript" src="{$BASE_PATH_JS}/StatesDropdown.js"></script>
<script type="text/javascript" src="{$BASE_PATH_JS}/PasswordStrength.js"></script>
<script type="text/javascript" src="{$BASE_PATH_JS}/VatValidator.js"></script>
<script>
    window.langPasswordStrength = "{$LANG.pwstrength}";
    window.langPasswordWeak = "{$LANG.pwstrengthweak}";
    window.langPasswordModerate = "{$LANG.pwstrengthmoderate}";
    window.langPasswordStrong = "{$LANG.pwstrengthstrong}";
    window.langVatErrorInvalidFormat = "{$LANG.tax.errorVatInvalidFormat}";
</script>
<div id="order-standard_cart" class="hide-cart-side-panels">
<style>
/* Cart-page layout overrides. Inlined on purpose: WHMCS caches the
   external custom.css under a fixed ?v= hash, so edits to that file can
   be ignored by the browser. Inline rules ship with the page HTML. */
#order-standard_cart.hide-cart-side-panels .cart-sidebar,
#order-standard_cart.hide-cart-side-panels .sidebar-collapsed {
    display: none !important;
}
#order-standard_cart.hide-cart-side-panels .cart-body {
    float: none;
    width: 100%;
}
/* Match the View Cart / Configure Product pages: keep the float-based two
   column layout so the theme's #scrollingPanelContainer scroll script drives
   the Order Summary exactly the same way (and auto-disables it on mobile, where
   the column becomes float:none and stacks below the form). Below 1200px the
   base order-form stylesheet handles the responsive widths. */
@media only screen and (min-width: 1200px) {
    #order-standard_cart.hide-cart-side-panels .secondary-cart-body {
        width: 73.75%;
    }
    #order-standard_cart.hide-cart-side-panels .secondary-cart-sidebar {
        width: 26.25%;
    }
}

/* Spacing under the merged cart-review section. */
#order-standard_cart .cart-review-merged {
    margin-bottom: 35px;
}

/* Keep the "Join our mailing list" toggle tidy inside the column. */
#order-standard_cart .marketing-email-optin .bootstrap-switch {
    margin-top: 6px;
    max-width: 100%;
}

/* Space above the Order Summary when it stacks below the form on mobile, so it
   isn't touching the mailing-list toggle. Padding (not margin) survives the
   scroll script, which zeroes the container's margin-top while stacked. */
@media only screen and (max-width: 991.98px) {
    #order-standard_cart.hide-cart-side-panels #scrollingPanelContainer {
        padding-top: 30px;
    }
}

/* Payment methods: one per row, gateway name on the left, logo on the right. */
#order-standard_cart .payment-methods-list {
    text-align: left;
    margin-top: 10px;
    border: 1px solid rgba(128, 128, 128, 0.35);
    border-radius: 8px;
    overflow: hidden;
}
#order-standard_cart .payment-method-row {
    display: flex !important;
    align-items: center;
    justify-content: space-between;
    width: 100%;
    margin: 0;
    padding: 14px 16px;
    border: 0;
    border-bottom: 1px solid rgba(0, 0, 0, 0.12);
    border-radius: 0;
    cursor: pointer;
    background-color: #ffffff;
    color: #222222;
    transition: background-color .15s ease;
}
#order-standard_cart .payment-method-row:last-child {
    border-bottom: 0;
}
#order-standard_cart .payment-method-row:hover {
    background-color: #f5f5f5;
}
#order-standard_cart .payment-method-main {
    display: inline-flex;
    align-items: center;
    gap: 10px;
    margin: 0;
}
#order-standard_cart .payment-method-name {
    font-weight: 600;
}
#order-standard_cart .payment-method-logo {
    display: inline-flex;
    align-items: center;
    min-height: 26px;
}
#order-standard_cart .payment-method-logo img {
    max-height: 26px;
    width: auto;
}

/* Stacked field labels: label sits above the input. */
#order-standard_cart .stacked-field {
    margin-bottom: 16px;
}
#order-standard_cart .stacked-label {
    display: block;
    margin-bottom: 6px;
    font-size: 0.85em;
    font-weight: 500;
    opacity: 0.85;
}
#order-standard_cart .stacked-field .field,
#order-standard_cart .stacked-field .form-control {
    width: 100%;
}
#order-standard_cart .required-asterisk {
    color: #e25555;
    margin-left: 2px;
}
#order-standard_cart .optional-hint {
    font-weight: 400;
    font-size: 0.95em;
    opacity: 0.6;
}

/* Account-type tabs, styled like the cart's promo tabs (nav-tabs). */
#order-standard_cart .account-type-tabs {
    margin-bottom: 18px;
}
#order-standard_cart .account-type-tabs .nav-link {
    cursor: pointer;
}
/* Legacy toggle buttons stay in the DOM (their handlers run the slide logic) but are hidden. */
#order-standard_cart .account-tabs-legacy { display: none !important; }

/* Cart actions row: Continue Shopping (left) and Empty Cart (right). */
#order-standard_cart .empty-cart {
    display: flex;
    align-items: center;
    justify-content: space-between;
    text-align: left;
}
#order-standard_cart .continue-shopping-link {
    font-size: 0.9em;
    color: inherit;
    opacity: 0.85;
}
#order-standard_cart .continue-shopping-link:hover {
    opacity: 1;
    text-decoration: underline;
}


/* Space between the cart items and the Apply Promo Code tab */
#order-standard_cart .view-cart-tabs {
    margin-top: 20px;
}
</style>

    <div class="row">
        <div class="cart-sidebar">
            {include file="orderforms/standard_cart/sidebar-categories.tpl"}
        </div>
        <div class="cart-body">
            <div class="header-lined">
                <h1 class="font-size-36">{$LANG.cartreviewcheckout}</h1>
            </div>
            {include file="orderforms/standard_cart/sidebar-categories-collapsed.tpl"}

            <div class="alert alert-danger checkout-error-feedback {if !$errormessage}d-none{/if}" role="alert">
                <p>{$LANG.orderForm.correctErrors}:</p>
                <ul>
                    {if $errormessage}
                        {$errormessage}
                    {/if}
                    <li class="vat-error d-none"></li>
                </ul>
            </div>

            <div class="row">
                <div class="secondary-cart-body">

                    {include file="orderforms/standard_cart/cart-review.tpl"}

                    <form method="post" action="{$smarty.server.PHP_SELF}?a=checkout" name="orderfrm" id="frmCheckout">
                        <input type="hidden" name="checkout" value="true" />
                        <input type="hidden" name="custtype" id="inputCustType" value="{$custtype}" />
                        {if $taxIdValidationEnabled}
                            <input type="hidden" id="validation_tax_id" value="true">
                        {/if}

                        {if $isTaxEUTaxExempt}
                            <input type="hidden" id="isTaxEUTaxExempt" value="true">
                        {/if}

                        {if $taxType !== ''}
                            <input type="hidden" id="taxType" value="{$taxType}">
                        {/if}

                        {if $isTaxInclusiveDeduct}
                            <input type="hidden" id="isTaxInclusiveDeduct" value="true">
                        {/if}

                        {if !$loggedin}
                        <div class="account-type-tabs">
                            <ul class="nav nav-tabs" role="tablist">
                                <li role="presentation" class="nav-item{if $custtype eq "existing"} active{/if}">
                                    <a href="#" class="nav-link account-type-link{if $custtype eq "existing"} active{/if}" data-account-type="existing" role="tab">
                                        {$LANG.orderForm.alreadyRegistered}
                                    </a>
                                </li>
                                <li role="presentation" class="nav-item{if $custtype neq "existing"} active{/if}">
                                    <a href="#" class="nav-link account-type-link{if $custtype neq "existing"} active{/if}" data-account-type="new" role="tab">
                                        {$LANG.orderForm.createAccount}
                                    </a>
                                </li>
                            </ul>
                        </div>
                        {/if}

                        <div class="already-registered clearfix account-tabs-legacy">
                            <div class="pull-right float-right">
                                <button type="button" class="btn btn-info{if $loggedin || !$loggedin && $custtype eq "existing"} w-hidden{/if}" id="btnAlreadyRegistered">
                                    {$LANG.orderForm.alreadyRegistered}
                                </button>
                                <button type="button" class="btn btn-warning{if $loggedin || $custtype neq "existing"} w-hidden{/if}" id="btnNewUserSignup">
                                    {$LANG.orderForm.createAccount}
                                </button>
                            </div>
                            <p class="text-sm-left overflow-hidden">{lang key='orderForm.enterPersonalDetails'}</p>
                        </div>


                {if $custtype neq "new" && $loggedin}
                    <div class="sub-heading">
                        <span class="primary-bg-color">
                            {lang key='switchAccount.title'}
                        </span>
                    </div>
                    <div id="containerExistingAccountSelect" class="row account-select-container">
                        {foreach $accounts as $account}
                            <div class="col-sm-{if $accounts->count() == 1}12{else}6{/if}">
                                <div class="account{if $selectedAccountId == $account->id} active{/if}">
                                    <label class="radio-inline" for="account{$account->id}">
                                        <input id="account{$account->id}" class="account-select{if $account->isClosed || $account->noPermission || $inExpressCheckout} disabled{/if}" type="radio" name="account_id" value="{$account->id}"{if $account->isClosed || $account->noPermission || $inExpressCheckout} disabled="disabled"{/if}{if $selectedAccountId == $account->id} checked="checked"{/if}>
                                        <span class="address">
                                            <strong>
                                                {if $account->company}{$account->company}{else}{$account->fullName}{/if}
                                            </strong>
                                            {if $account->isClosed || $account->noPermission}
                                                <span class="label label-default">
                                                    {if $account->isClosed}
                                                        {lang key='closed'}
                                                    {else}
                                                        {lang key='noPermission'}
                                                    {/if}
                                                </span>
                                            {elseif $account->currencyCode}
                                                <span class="label label-info">
                                                    {$account->currencyCode}
                                                </span>
                                            {/if}
                                            <br>
                                            <span class="small">
                                                {$account->address1}{if $account->address2}, {$account->address2}{/if}<br>
                                                {if $account->city}{$account->city},{/if}
                                                {if $account->state} {$account->state},{/if}
                                                {if $account->postcode} {$account->postcode},{/if}
                                                {$account->countryName}
                                            </span>
                                        </span>
                                    </label>
                                </div>
                            </div>
                        {/foreach}
                        <div class="col-sm-12">
                            <div class="account border-bottom{if !$selectedAccountId || !is_numeric($selectedAccountId)} active{/if}">
                                <label class="radio-inline">
                                    <input class="account-select" type="radio" name="account_id" value="new"{if !$selectedAccountId || !is_numeric($selectedAccountId)} checked="checked"{/if}{if $inExpressCheckout} disabled="disabled" class="disabled"{/if}>
                                    {lang key='orderForm.createAccount'}
                                </label>
                            </div>
                        </div>
                    </div>
                {/if}

                <div id="containerExistingUserSignin"{if $loggedin || $custtype neq "existing"} class="w-hidden{/if}">
                    <div class="sub-heading">
                        <span class="primary-bg-color">{$LANG.orderForm.existingCustomerLogin}</span>
                    </div>

                    <div class="alert alert-danger w-hidden" id="existingLoginMessage">
                    </div>

                    <div class="row">
                        <div class="col-sm-6">
                            <div class="form-group stacked-field">
                                <label for="inputLoginEmail" class="stacked-label">{$LANG.orderForm.emailAddress}<span class="required-asterisk">*</span></label>
                                <div class="prepend-icon">
                                    <label for="inputLoginEmail" class="field-icon"><i class="fas fa-envelope"></i></label>
                                    <input type="text" name="loginemail" autocomplete="email" id="inputLoginEmail" class="field form-control" placeholder="{$LANG.orderForm.emailAddress}" value="{$loginemail}">
                                </div>
                            </div>
                        </div>
                        <div class="col-sm-6">
                            <div class="form-group stacked-field">
                                <label for="inputLoginPassword" class="stacked-label">{$LANG.clientareapassword}<span class="required-asterisk">*</span></label>
                                <div class="prepend-icon">
                                    <label for="inputLoginPassword" class="field-icon"><i class="fas fa-lock"></i></label>
                                    <input type="password" name="loginpassword" autocomplete="current-password" id="inputLoginPassword" class="field form-control" placeholder="{$LANG.clientareapassword}">
                                </div>
                            </div>
                        </div>
                    </div>

                    <div class="text-center">
                        <button type="button" id="btnExistingLogin" class="btn btn-primary btn-md">
                            <span id="existingLoginButton">{lang key='login'}</span>
                            <span id="existingLoginPleaseWait" class="w-hidden">{lang key='pleasewait'}</span>
                        </button>
                    </div>

                    {include file="orderforms/standard_cart/linkedaccounts.tpl" linkContext="checkout-existing"}
                </div>
                <div id="containerNewUserSignup"
                    {if
                        $custtype === 'existing'
                        || (is_numeric($selectedAccountId) && $selectedAccountId > 0)
                        || (
                            $loggedin
                            && $selectedAccountId !== 'new'
                            && $custtype !== 'add'
                        )
                    }
                        class="w-hidden"
                    {/if}
                >

                    <div{if $loggedin} class="w-hidden"{/if}>
                        {include file="orderforms/standard_cart/linkedaccounts.tpl" linkContext="checkout-new"}
                    </div>

                    <div class="sub-heading">
                        <span class="primary-bg-color">{$LANG.orderForm.personalInformation}</span>
                    </div>

                    <div class="row">
                        <div class="col-sm-6">
                            <div class="form-group stacked-field">
                                <label for="inputFirstName" class="stacked-label">{$LANG.orderForm.firstName}{if !in_array('firstname', $clientsProfileOptionalFields)}<span class="required-asterisk">*</span>{else} <span class="optional-hint">(Optional)</span>{/if}</label>
                                <div class="prepend-icon">
                                    <label for="inputFirstName" class="field-icon"><i class="fas fa-user"></i></label>
                                    <input type="text" name="firstname" autocomplete="given-name" id="inputFirstName" class="field form-control" placeholder="{$LANG.orderForm.firstName}" value="{$clientsdetails.firstname}" autofocus>
                                </div>
                            </div>
                        </div>
                        <div class="col-sm-6">
                            <div class="form-group stacked-field">
                                <label for="inputLastName" class="stacked-label">{$LANG.orderForm.lastName}{if !in_array('lastname', $clientsProfileOptionalFields)}<span class="required-asterisk">*</span>{else} <span class="optional-hint">(Optional)</span>{/if}</label>
                                <div class="prepend-icon">
                                    <label for="inputLastName" class="field-icon"><i class="fas fa-user"></i></label>
                                    <input type="text" name="lastname" autocomplete="family-name" id="inputLastName" class="field form-control" placeholder="{$LANG.orderForm.lastName}" value="{$clientsdetails.lastname}">
                                </div>
                            </div>
                        </div>
                        <div class="col-sm-6">
                            <div class="form-group stacked-field">
                                <label for="inputEmail" class="stacked-label">{$LANG.orderForm.emailAddress}{if !in_array('email', $clientsProfileOptionalFields)}<span class="required-asterisk">*</span>{else} <span class="optional-hint">(Optional)</span>{/if}</label>
                                <div class="prepend-icon">
                                    <label for="inputEmail" class="field-icon"><i class="fas fa-envelope"></i></label>
                                    <input type="email" name="email" autocomplete="email" id="inputEmail" class="field form-control" placeholder="{$LANG.orderForm.emailAddress}" value="{$clientsdetails.email}">
                                </div>
                            </div>
                        </div>
                        <div class="col-sm-6">
                            <div class="form-group stacked-field">
                                <label for="inputPhone" class="stacked-label">{$LANG.orderForm.phoneNumber}{if !in_array('phonenumber', $clientsProfileOptionalFields)}<span class="required-asterisk">*</span>{else} <span class="optional-hint">(Optional)</span>{/if}</label>
                                <input type="tel" name="phonenumber" autocomplete="tel" id="inputPhone" class="field form-control" placeholder="{$LANG.orderForm.phoneNumber}" value="{$clientsdetails.phonenumber}">
                            </div>
                        </div>
                    </div>

                    <div class="sub-heading">
                        <span class="primary-bg-color">{$LANG.orderForm.billingAddress}</span>
                    </div>

                    <div class="row">
                        <div class="col-sm-12">
                            <div class="form-group stacked-field">
                                <label for="inputCompanyName" class="stacked-label">{$LANG.orderForm.companyName} ({$LANG.orderForm.optional})</label>
                                <div class="prepend-icon">
                                    <label for="inputCompanyName" class="field-icon"><i class="fas fa-building"></i></label>
                                    <input type="text" name="companyname" autocomplete="organization" id="inputCompanyName" class="field form-control" placeholder="{$LANG.orderForm.companyName} ({$LANG.orderForm.optional})" value="{$clientsdetails.companyname}">
                                </div>
                            </div>
                        </div>
                        <div class="col-sm-12">
                            <div class="form-group stacked-field">
                                <label for="inputAddress1" class="stacked-label">{$LANG.orderForm.streetAddress}{if !in_array('address1', $clientsProfileOptionalFields)}<span class="required-asterisk">*</span>{else} <span class="optional-hint">(Optional)</span>{/if}</label>
                                <div class="prepend-icon">
                                    <label for="inputAddress1" class="field-icon"><i class="far fa-building"></i></label>
                                    <input type="text" name="address1" autocomplete="address-line1" id="inputAddress1" class="field form-control" placeholder="{$LANG.orderForm.streetAddress}" value="{$clientsdetails.address1}">
                                </div>
                            </div>
                        </div>
                        <div class="col-sm-12">
                            <div class="form-group stacked-field">
                                <label for="inputAddress2" class="stacked-label">{$LANG.orderForm.streetAddress2}</label>
                                <div class="prepend-icon">
                                    <label for="inputAddress2" class="field-icon"><i class="fas fa-map-marker-alt"></i></label>
                                    <input type="text" name="address2" autocomplete="address-line2" id="inputAddress2" class="field form-control" placeholder="{$LANG.orderForm.streetAddress2}" value="{$clientsdetails.address2}">
                                </div>
                            </div>
                        </div>
                        <div class="col-sm-4">
                            <div class="form-group stacked-field">
                                <label for="inputCity" class="stacked-label">{$LANG.orderForm.city}{if !in_array('city', $clientsProfileOptionalFields)}<span class="required-asterisk">*</span>{else} <span class="optional-hint">(Optional)</span>{/if}</label>
                                <div class="prepend-icon">
                                    <label for="inputCity" class="field-icon"><i class="far fa-building"></i></label>
                                    <input type="text" name="city" autocomplete="address-level2" id="inputCity" class="field form-control" placeholder="{$LANG.orderForm.city}" value="{$clientsdetails.city}">
                                </div>
                            </div>
                        </div>
                        <div class="col-sm-5">
                            <div class="form-group stacked-field">
                                <label for="inputState" class="stacked-label">{$LANG.orderForm.state}{if !in_array('state', $clientsProfileOptionalFields)}<span class="required-asterisk">*</span>{else} <span class="optional-hint">(Optional)</span>{/if}</label>
                                <div class="prepend-icon">
                                    <label for="inputState" class="field-icon"><i class="fas fa-map-signs"></i></label>
                                    <input type="text" name="state" autocomplete="address-level1" id="inputState" class="field form-control" placeholder="{$LANG.orderForm.state}" value="{$clientsdetails.state}">
                                </div>
                            </div>
                        </div>
                        <div class="col-sm-3">
                            <div class="form-group stacked-field">
                                <label for="inputPostcode" class="stacked-label">{$LANG.orderForm.postcode}{if !in_array('postcode', $clientsProfileOptionalFields)}<span class="required-asterisk">*</span>{else} <span class="optional-hint">(Optional)</span>{/if}</label>
                                <div class="prepend-icon">
                                    <label for="inputPostcode" class="field-icon"><i class="fas fa-certificate"></i></label>
                                    <input type="text" name="postcode" autocomplete="postal-code" id="inputPostcode" class="field form-control" placeholder="{$LANG.orderForm.postcode}" value="{$clientsdetails.postcode}">
                                </div>
                            </div>
                        </div>
                        <div class="col-sm-12">
                            <div class="form-group stacked-field">
                                <label for="inputCountry" class="stacked-label">{$LANG.orderForm.country}{if !in_array('country', $clientsProfileOptionalFields)}<span class="required-asterisk">*</span>{else} <span class="optional-hint">(Optional)</span>{/if}</label>
                                <div class="prepend-icon">
                                    <label for="inputCountry" class="field-icon"><i class="fas fa-globe"></i></label>
                                    <select name="country" autocomplete="country" id="inputCountry" class="field form-control">
                                    {foreach $countries as $countrycode => $countrylabel}
                                        <option value="{$countrycode}"{if (!$country && $countrycode == $defaultcountry) || $countrycode eq $country} selected{/if}>
                                            {$countrylabel}
                                        </option>
                                    {/foreach}
                                </select>
                                </div>
                            </div>
                        </div>
                        {if $showTaxIdField}
                            <div class="col-sm-12">
                                <div class="form-group stacked-field">
                                <label for="inputTaxId" class="stacked-label">{$taxLabel}</label>
                                <div class="prepend-icon">
                                    <label for="inputTaxId" class="field-icon"><i class="fas fa-building"></i></label>
                                    <input type="text" name="tax_id" id="inputTaxId" class="field form-control" placeholder="{$taxLabel}" value="{$clientsdetails.tax_id}" autocomplete="off">
                                </div>
                            </div>
                            </div>
                        {/if}
                    </div>

                    {if $customfields}
                        <div class="sub-heading">
                            <span class="primary-bg-color">{$LANG.orderadditionalrequiredinfo}<br><i><small>{lang key='orderForm.requiredField'}</small></i></span>
                        </div>
                        <div class="field-container">
                            <div class="row">
                                {foreach $customfields as $customfield}
                                    <div class="col-sm-6">
                                        <div class="form-group">
                                            <label for="customfield{$customfield.id}">{$customfield.name} {$customfield.required}</label>
                                            {$customfield.input}
                                            {if $customfield.description}
                                                <span class="field-help-text">
                                                    {$customfield.description}
                                                </span>
                                            {/if}
                                        </div>
                                    </div>
                                {/foreach}
                            </div>
                        </div>
                    {/if}

                </div>

                {if isset($checkoutExtraFields) && !empty($checkoutExtraFields)}
                    <div class="sub-heading">
                        <span class="primary-bg-color">{lang key='orderForm.additionalInformation'}</span>
                    </div>
                    <div class="row">
                        {foreach $checkoutExtraFields as $field}
                            <div class="col-sm-6">
                                <div class="form-group">
                                    <label for="{$field.name}">
                                        {$field.label|escape}
                                        {if $field.required}<span class="text-danger">*</span>{/if}
                                    </label>
                                    {$field.input}
                                    {if $field.description}
                                        <span class="field-help-text">{$field.description}</span>
                                    {/if}
                                </div>
                            </div>
                        {/foreach}
                    </div>
                {/if}

                {if $domainsinorder}

                    <div class="sub-heading">
                        <span class="primary-bg-color">{$LANG.domainregistrantinfo}</span>
                    </div>

                    <p class="small text-muted">{$LANG.orderForm.domainAlternativeContact}</p>

                    <div class="row margin-bottom">
                        <div class="col-sm-6 col-sm-offset-3 offset-sm-3">
                            <select name="contact" id="inputDomainContact" class="field form-control">
                                <option value="">{$LANG.usedefaultcontact}</option>
                                {foreach $domaincontacts as $domcontact}
                                    <option value="{$domcontact.id}"{if $contact == $domcontact.id} selected{/if}>
                                        {$domcontact.name}
                                    </option>
                                {/foreach}
                                <option value="addingnew"{if $contact == "addingnew"} selected{/if}>
                                    {$LANG.clientareanavaddcontact}...
                                </option>
                            </select>
                        </div>
                    </div>

                    <div{if $contact neq "addingnew"} class="w-hidden"{/if}>
                        <div class="row" id="domainRegistrantInputFields">
                            <div class="col-sm-6">
                                <div class="form-group stacked-field">
                                <label for="inputDCFirstName" class="stacked-label">{$LANG.orderForm.firstName}{if !in_array('firstname', $clientsProfileOptionalFields)}<span class="required-asterisk">*</span>{else} <span class="optional-hint">(Optional)</span>{/if}</label>
                                <div class="prepend-icon">
                                    <label for="inputDCFirstName" class="field-icon"><i class="fas fa-user"></i></label>
                                    <input type="text" name="domaincontactfirstname" id="inputDCFirstName" class="field form-control" placeholder="{$LANG.orderForm.firstName}" value="{$domaincontact.firstname}">
                                </div>
                            </div>
                            </div>
                            <div class="col-sm-6">
                                <div class="form-group stacked-field">
                                <label for="inputDCLastName" class="stacked-label">{$LANG.orderForm.lastName}{if !in_array('lastname', $clientsProfileOptionalFields)}<span class="required-asterisk">*</span>{else} <span class="optional-hint">(Optional)</span>{/if}</label>
                                <div class="prepend-icon">
                                    <label for="inputDCLastName" class="field-icon"><i class="fas fa-user"></i></label>
                                    <input type="text" name="domaincontactlastname" id="inputDCLastName" class="field form-control" placeholder="{$LANG.orderForm.lastName}" value="{$domaincontact.lastname}">
                                </div>
                            </div>
                            </div>
                            <div class="col-sm-6">
                                <div class="form-group stacked-field">
                                <label for="inputDCEmail" class="stacked-label">{$LANG.orderForm.emailAddress}{if !in_array('email', $clientsProfileOptionalFields)}<span class="required-asterisk">*</span>{else} <span class="optional-hint">(Optional)</span>{/if}</label>
                                <div class="prepend-icon">
                                    <label for="inputDCEmail" class="field-icon"><i class="fas fa-envelope"></i></label>
                                    <input type="email" name="domaincontactemail" id="inputDCEmail" class="field form-control" placeholder="{$LANG.orderForm.emailAddress}" value="{$domaincontact.email}">
                                </div>
                            </div>
                            </div>
                            <div class="col-sm-6">
                                <div class="form-group stacked-field">
                                <label for="inputDCPhone" class="stacked-label">{$LANG.orderForm.phoneNumber}{if !in_array('phonenumber', $clientsProfileOptionalFields)}<span class="required-asterisk">*</span>{else} <span class="optional-hint">(Optional)</span>{/if}</label>
                                <input type="tel" name="domaincontactphonenumber" id="inputDCPhone" class="field form-control" placeholder="{$LANG.orderForm.phoneNumber}" value="{$domaincontact.phonenumber}">
                            </div>
                            </div>
                            <div class="col-sm-12">
                                <div class="form-group stacked-field">
                                <label for="inputDCCompanyName" class="stacked-label">{$LANG.orderForm.companyName} ({$LANG.orderForm.optional})</label>
                                <div class="prepend-icon">
                                    <label for="inputDCCompanyName" class="field-icon"><i class="fas fa-building"></i></label>
                                    <input type="text" name="domaincontactcompanyname" id="inputDCCompanyName" class="field form-control" placeholder="{$LANG.orderForm.companyName} ({$LANG.orderForm.optional})" value="{$domaincontact.companyname}">
                                </div>
                            </div>
                            </div>
                            <div class="col-sm-12">
                                <div class="form-group stacked-field">
                                <label for="inputDCAddress1" class="stacked-label">{$LANG.orderForm.streetAddress}{if !in_array('address1', $clientsProfileOptionalFields)}<span class="required-asterisk">*</span>{else} <span class="optional-hint">(Optional)</span>{/if}</label>
                                <div class="prepend-icon">
                                    <label for="inputDCAddress1" class="field-icon"><i class="far fa-building"></i></label>
                                    <input type="text" name="domaincontactaddress1" id="inputDCAddress1" class="field form-control" placeholder="{$LANG.orderForm.streetAddress}" value="{$domaincontact.address1}">
                                </div>
                            </div>
                            </div>
                            <div class="col-sm-12">
                                <div class="form-group stacked-field">
                                <label for="inputDCAddress2" class="stacked-label">{$LANG.orderForm.streetAddress2}</label>
                                <div class="prepend-icon">
                                    <label for="inputDCAddress2" class="field-icon"><i class="fas fa-map-marker-alt"></i></label>
                                    <input type="text" name="domaincontactaddress2" id="inputDCAddress2" class="field form-control" placeholder="{$LANG.orderForm.streetAddress2}" value="{$domaincontact.address2}">
                                </div>
                            </div>
                            </div>
                            <div class="col-sm-4">
                                <div class="form-group stacked-field">
                                <label for="inputDCCity" class="stacked-label">{$LANG.orderForm.city}{if !in_array('city', $clientsProfileOptionalFields)}<span class="required-asterisk">*</span>{else} <span class="optional-hint">(Optional)</span>{/if}</label>
                                <div class="prepend-icon">
                                    <label for="inputDCCity" class="field-icon"><i class="far fa-building"></i></label>
                                    <input type="text" name="domaincontactcity" id="inputDCCity" class="field form-control" placeholder="{$LANG.orderForm.city}" value="{$domaincontact.city}">
                                </div>
                            </div>
                            </div>
                            <div class="col-sm-5">
                                <div class="form-group stacked-field">
                                <label for="inputDCState" class="stacked-label">{$LANG.orderForm.state}{if !in_array('state', $clientsProfileOptionalFields)}<span class="required-asterisk">*</span>{else} <span class="optional-hint">(Optional)</span>{/if}</label>
                                <div class="prepend-icon">
                                    <label for="inputDCState" class="field-icon"><i class="fas fa-map-signs"></i></label>
                                    <input type="text" name="domaincontactstate" id="inputDCState" class="field form-control" placeholder="{$LANG.orderForm.state}" value="{$domaincontact.state}">
                                </div>
                            </div>
                            </div>
                            <div class="col-sm-3">
                                <div class="form-group stacked-field">
                                <label for="inputDCPostcode" class="stacked-label">{$LANG.orderForm.postcode}{if !in_array('postcode', $clientsProfileOptionalFields)}<span class="required-asterisk">*</span>{else} <span class="optional-hint">(Optional)</span>{/if}</label>
                                <div class="prepend-icon">
                                    <label for="inputDCPostcode" class="field-icon"><i class="fas fa-certificate"></i></label>
                                    <input type="text" name="domaincontactpostcode" id="inputDCPostcode" class="field form-control" placeholder="{$LANG.orderForm.postcode}" value="{$domaincontact.postcode}">
                                </div>
                            </div>
                            </div>
                            <div class="col-sm-12">
                                <div class="form-group stacked-field">
                                <label for="inputDCCountry" class="stacked-label">{$LANG.orderForm.country}{if !in_array('country', $clientsProfileOptionalFields)}<span class="required-asterisk">*</span>{else} <span class="optional-hint">(Optional)</span>{/if}</label>
                                <div class="prepend-icon">
                                    <label for="inputDCCountry" class="field-icon"><i class="fas fa-globe"></i></label>
                                    <select name="domaincontactcountry" id="inputDCCountry" class="field form-control">
                                        {foreach $countries as $countrycode => $countrylabel}
                                            <option value="{$countrycode}"{if (!$domaincontact.country && $countrycode == $defaultcountry) || $countrycode eq $domaincontact.country} selected{/if}>
                                                {$countrylabel}
                                            </option>
                                        {/foreach}
                                    </select>
                                </div>
                            </div>
                            </div>
                            <div class="col-sm-12">
                                <div class="form-group stacked-field">
                                <label for="inputDCTaxId" class="stacked-label">{$taxLabel}</label>
                                <div class="prepend-icon">
                                    <label for="inputDCTaxId" class="field-icon"><i class="fas fa-building"></i></label>
                                    <input type="text" name="domaincontacttax_id" id="inputDCTaxId" class="field form-control" placeholder="{$taxLabel}" value="{$domaincontact.tax_id}" autocomplete="off">
                                </div>
                            </div>
                            </div>
                        </div>
                    </div>

                {/if}

                {if !$loggedin}

                    <div id="containerNewUserSecurity"{if (!$loggedin && $custtype eq "existing") || ($remote_auth_prelinked && !$securityquestions)} class="w-hidden"{/if}>

                        <div class="sub-heading">
                            <span class="primary-bg-color">{$LANG.orderForm.accountSecurity}</span>
                        </div>

                        <div id="containerPassword" class="row{if $remote_auth_prelinked && $securityquestions} w-hidden{/if}">
                            <div id="passwdFeedback" class="alert alert-info text-center col-sm-12 w-hidden"></div>
                            <div class="col-sm-6">
                                <div class="form-group stacked-field">
                                <label for="inputNewPassword1" class="stacked-label">{$LANG.clientareapassword}<span class="required-asterisk">*</span></label>
                                <div class="prepend-icon">
                                    <label for="inputNewPassword1" class="field-icon"><i class="fas fa-lock"></i></label>
                                    <input type="password" name="password" autocomplete="new-password" id="inputNewPassword1" data-error-threshold="{$pwStrengthErrorThreshold}" data-warning-threshold="{$pwStrengthWarningThreshold}" class="field form-control" placeholder="{$LANG.clientareapassword}"{if $remote_auth_prelinked} value="{$password}"{/if}>
                                </div>
                            </div>
                            </div>
                            <div class="col-sm-6">
                                <div class="form-group stacked-field">
                                <label for="inputNewPassword2" class="stacked-label">{$LANG.clientareaconfirmpassword}<span class="required-asterisk">*</span></label>
                                <div class="prepend-icon">
                                    <label for="inputNewPassword2" class="field-icon"><i class="fas fa-lock"></i></label>
                                    <input type="password" name="password2" autocomplete="new-password" id="inputNewPassword2" class="field form-control" placeholder="{$LANG.clientareaconfirmpassword}"{if $remote_auth_prelinked} value="{$password}"{/if}>
                                </div>
                            </div>
                            </div>
                            <div class="col-sm-6">
                                <button type="button" class="btn btn-default btn-sm generate-password" data-targetfields="inputNewPassword1,inputNewPassword2">
                                    {$LANG.generatePassword.btnLabel}
                                </button>
                            </div>
                            <div class="col-sm-6">
                                <div class="password-strength-meter">
                                    <div class="progress">
                                        <div class="progress-bar progress-bar-success progress-bar-striped" role="progressbar" aria-valuenow="0" aria-valuemin="0" aria-valuemax="100" id="passwordStrengthMeterBar">
                                        </div>
                                    </div>
                                    <p class="text-center small text-muted" id="passwordStrengthTextLabel">{$LANG.pwstrength}: {$LANG.pwstrengthenter}</p>
                                </div>
                            </div>
                        </div>
                        {if $securityquestions}
                            <div class="row">
                                <div class="col-sm-6">
                                    <select name="securityqid" id="inputSecurityQId" class="field form-control">
                                        <option value="">{$LANG.clientareasecurityquestion}</option>
                                        {foreach $securityquestions as $question}
                                            <option value="{$question.id}"{if $question.id eq $securityqid} selected{/if}>
                                                {$question.question}
                                            </option>
                                        {/foreach}
                                    </select>
                                </div>
                                <div class="col-sm-6">
                                    <div class="form-group stacked-field">
                                <label for="inputSecurityQAns" class="stacked-label">{$LANG.clientareasecurityanswer}<span class="required-asterisk">*</span></label>
                                <div class="prepend-icon">
                                    <label for="inputSecurityQAns" class="field-icon"><i class="fas fa-lock"></i></label>
                                    <input type="password" name="securityqans" id="inputSecurityQAns" class="field form-control" placeholder="{$LANG.clientareasecurityanswer}">
                                </div>
                            </div>
                                </div>
                            </div>
                        {/if}

                    </div>

                {/if}

                {foreach $hookOutput as $output}
                    <div>
                        {$output}
                    </div>
                {/foreach}

                {if $captcha && $captcha->isEnabled() && $captcha->isEnabledForForm($captchaForm)}
                    {if !$captcha->isInvisible()}
                        <div class="sub-heading">
                            <span class="primary-bg-color">{$LANG.captchatitle}</span>
                        </div>
                    {/if}
                    <div class="text-center">
                        <div class="text-center margin-bottom">
                            {include file="$template/includes/captcha.tpl"}
                        </div>
                    </div>
                {/if}

                <div class="sub-heading">
                    <span class="primary-bg-color">{$LANG.orderForm.paymentDetails}</span>
                </div>


                <div id="applyCreditContainer" class="apply-credit-container{if !$canUseCreditOnCheckout} w-hidden{/if}" data-apply-credit="{$applyCredit}">
                    <p>{lang key='cart.availableCreditBalance' amount=$creditBalance}</p>

                    <label class="radio">
                        <input id="useCreditOnCheckout" type="radio" name="applycredit" value="1"{if $applyCredit} checked{/if}>
                        <span id="spanFullCredit"{if !($creditBalance->toNumeric() >= $total->toNumeric())} class="w-hidden"{/if}>
                            {lang key='cart.applyCreditAmountNoFurtherPayment' amount=$total}
                        </span>
                        <span id="spanUseCredit"{if $creditBalance->toNumeric() >= $total->toNumeric()} class="w-hidden"{/if}>
                            {lang key='cart.applyCreditAmount' amount=$creditBalance}
                        </span>
                    </label>
                    <label class="radio">
                        <input id="skipCreditOnCheckout" type="radio" name="applycredit" value="0"{if !$applyCredit} checked{/if}>
                        {lang key='cart.applyCreditSkip' amount=$creditBalance}
                    </label>
                </div>

                {if !$inExpressCheckout}
                    <div id="paymentGatewaysContainer" class="form-group">
                        <p class="small text-muted">{$LANG.orderForm.preferredPaymentMethod}</p>

                        <div class="payment-methods-list">
                            {foreach $gateways as $gateway}
                                {assign var="gwMatch" value=$gateway.sysname|cat:" "|cat:$gateway.name|lower}
                                <label class="radio-inline payment-method-row">
                                    <span class="payment-method-main">
                                        <input type="radio"
                                               name="paymentmethod"
                                               value="{$gateway.sysname}"
                                               data-payment-type="{$gateway.payment_type}"
                                               data-show-local="{$gateway.show_local_cards}"
                                               data-remote-inputs="{$gateway.uses_remote_inputs}"
                                               class="payment-methods{if $gateway.type eq "CC"} is-credit-card{/if}"
                                                {if $selectedgateway eq $gateway.sysname} checked{/if}
                                        />
                                        <span class="payment-method-name">{$gateway.name}</span>
                                    </span>
                                    <span class="payment-method-logo">
                                        {if $gwMatch|strstr:"paypal"}
                                            <img src="{$WEB_ROOT}/assets/img/gateways/paypal.svg" alt="{$gateway.name}" onerror="this.style.display='none'">
                                        {elseif $gwMatch|strstr:"stripe"}
                                            <img src="{$WEB_ROOT}/assets/img/gateways/stripe.svg" alt="{$gateway.name}" onerror="this.style.display='none'">
                                        {/if}
                                    </span>
                                </label>
                            {/foreach}
                        </div>
                    </div>

                    <div class="alert alert-danger text-center gateway-errors w-hidden"></div>

                    <div class="clearfix"></div>

                    <div id="paymentGatewayInput"></div>

                    <div class="cc-input-container{if $selectedgatewaytype neq "CC"} w-hidden{/if}" id="creditCardInputFields">
                        {if $client}
                            <div id="existingCardsContainer" class="existing-cc-grid">
                                {include file="orderforms/standard_cart/includes/existing-paymethods.tpl"}
                            </div>
                        {/if}
                        <div class="row cvv-input" id="existingCardInfo">
                            <div class="col-lg-3 col-sm-4">
                                <div class="form-group prepend-icon">
                                    <label for="inputCardCVV2" class="field-icon">
                                        <i class="fas fa-barcode"></i>
                                    </label>
                                    <div class="input-group">
                                        <input type="tel" name="cccvv" id="inputCardCVV2" class="field form-control" placeholder="{$LANG.creditcardcvvnumbershort}" autocomplete="cc-cvc">
                                        <span class="input-group-btn input-group-append">
                                            <button type="button" class="btn btn-default" data-toggle="popover" data-placement="bottom" data-content="<img src='{$BASE_PATH_IMG}/ccv.gif' width='210' />">
                                                ?
                                            </button>
                                        </span>
                                    </div>
                                    <span class="field-error-msg">{lang key="paymentMethodsManage.cvcNumberNotValid"}</span>
                                </div>
                            </div>
                        </div>

                        <ul>
                            <li>
                                <label class="radio-inline">
                                    <input type="radio" name="ccinfo" value="new" id="new" {if !$client || $client->payMethods->count() === 0} checked="checked"{/if} />
                                    &nbsp;
                                    {lang key='creditcardenternewcard'}
                                </label>
                            </li>
                        </ul>

                        <div class="row" id="newCardInfo">
                            <div id="cardNumberContainer" class="col-sm-6 new-card-container">
                                <div class="form-group prepend-icon">
                                    <label for="inputCardNumber" class="field-icon">
                                        <i class="fas fa-credit-card"></i>
                                    </label>
                                    <input type="tel" name="ccnumber" id="inputCardNumber" class="field form-control cc-number-field" placeholder="{$LANG.orderForm.cardNumber}" autocomplete="cc-number" data-message-unsupported="{lang key='paymentMethodsManage.unsupportedCardType'}" data-message-invalid="{lang key='paymentMethodsManage.cardNumberNotValid'}" data-supported-cards="{$supportedCardTypes}" />
                                    <span class="field-error-msg"></span>
                                </div>
                            </div>
                            <div class="col-sm-3 new-card-container">
                                <div class="form-group prepend-icon">
                                    <label for="inputCardExpiry" class="field-icon">
                                        <i class="fas fa-calendar-alt"></i>
                                    </label>
                                    <input type="tel" name="ccexpirydate" id="inputCardExpiry" class="field form-control" placeholder="MM / YY{if $showccissuestart} ({$LANG.creditcardcardexpires}){/if}" autocomplete="cc-exp">
                                    <span class="field-error-msg">{lang key="paymentMethodsManage.expiryDateNotValid"}</span>
                                </div>
                            </div>
                            <div class="col-sm-3" id="cvv-field-container">
                                <div class="form-group prepend-icon">
                                    <label for="inputCardCVV" class="field-icon">
                                        <i class="fas fa-barcode"></i>
                                    </label>
                                    <div class="input-group">
                                        <input type="tel" name="cccvv" id="inputCardCVV" class="field form-control" placeholder="{$LANG.creditcardcvvnumbershort}" autocomplete="cc-cvc">
                                        <span class="input-group-btn input-group-append">
                                            <button type="button" class="btn btn-default" data-toggle="popover" data-placement="bottom" data-content="<img src='{$BASE_PATH_IMG}/ccv.gif' width='210' />">
                                                ?
                                            </button>
                                        </span><br>
                                    </div>
                                    <span class="field-error-msg">{lang key="paymentMethodsManage.cvcNumberNotValid"}</span>
                                </div>
                            </div>
                            {if $showccissuestart}
                                <div class="col-sm-3 col-sm-offset-6 new-card-container offset-sm-6">
                                    <div class="form-group prepend-icon">
                                        <label for="inputCardStart" class="field-icon">
                                            <i class="far fa-calendar-check"></i>
                                        </label>
                                        <input type="tel" name="ccstartdate" id="inputCardStart" class="field form-control" placeholder="MM / YY ({$LANG.creditcardcardstart})" autocomplete="cc-exp">
                                    </div>
                                </div>
                                <div class="col-sm-3 new-card-container">
                                    <div class="form-group prepend-icon">
                                        <label for="inputCardIssue" class="field-icon">
                                            <i class="fas fa-asterisk"></i>
                                        </label>
                                        <input type="tel" name="ccissuenum" id="inputCardIssue" class="field form-control" placeholder="{$LANG.creditcardcardissuenum}">
                                    </div>
                                </div>
                            {/if}
                        </div>
                        <div id="newCardSaveSettings">
                            <div class="row form-group new-card-container">
                                <div id="inputDescriptionContainer" class="col-md-6">
                                    <div class="prepend-icon">
                                        <label for="inputDescription" class="field-icon">
                                            <i class="fas fa-pencil"></i>
                                        </label>
                                        <input type="text" class="field form-control" id="inputDescription" name="ccdescription" autocomplete="off" value="" placeholder="{$LANG.paymentMethods.descriptionInput} {$LANG.paymentMethodsManage.optional}" />
                                    </div>
                                </div>
                                {if $allowClientsToRemoveCards}
                                    <div id="inputNoStoreContainer" class="col-md-6" style="line-height: 32px;">
                                        <input type="hidden" name="nostore" value="1">
                                        <input type="checkbox" class="toggle-switch-success no-icheck" data-size="mini" checked="checked" name="nostore" id="inputNoStore" value="0" data-on-text="{lang key='yes'}" data-off-text="{lang key='no'}">
                                        <label for="inputNoStore" class="checkbox-inline no-padding">
                                            &nbsp;&nbsp;
                                            {$LANG.creditCardStore}
                                        </label>
                                    </div>
                                {/if}
                            </div>
                        </div>
                    </div>
                {else}
                    {if $expressCheckoutOutput}
                        {$expressCheckoutOutput}
                    {else}
                        <p align="center">
                            {lang key='paymentPreApproved' gateway=$expressCheckoutGateway}
                        </p>
                    {/if}
                {/if}

                {if $shownotesfield}

                    <div class="sub-heading">
                        <span class="primary-bg-color">{$LANG.orderForm.additionalNotes}</span>
                    </div>

                    <div class="row">
                        <div class="col-sm-12">
                            <div class="form-group">
                                <textarea name="notes" class="field form-control" rows="4" placeholder="{$LANG.ordernotesdescription}">{$orderNotes}</textarea>
                            </div>
                        </div>
                    </div>

                {/if}

                {if $showMarketingEmailOptIn}
                    <div class="marketing-email-optin">
                        <h4 class="font-size-18">{lang key='emailMarketing.joinOurMailingList'}</h4>
                        <p>{$marketingEmailOptInMessage}</p>
                        <input type="checkbox" name="marketingoptin" value="1"{if $marketingEmailOptIn} checked{/if} class="no-icheck toggle-switch-success" data-size="small" data-on-text="{lang key='yes'}" data-off-text="{lang key='no'}">
                    </div>
                {/if}

                    </form>
                </div><!-- /.secondary-cart-body -->

                    <div class="secondary-cart-sidebar" id="scrollingPanelContainer">
                        <div class="order-summary" id="orderSummary">
                            <div class="loader w-hidden" id="orderSummaryLoader">
                                <i class="fas fa-fw fa-sync fa-spin"></i>
                            </div>
                            <h2 class="font-size-30">{$LANG.ordersummary}</h2>
                            <div class="summary-container">

                                <div class="summary-figures">
                                <div class="subtotal clearfix">
                                    <span class="pull-left float-left">{$LANG.ordersubtotal}</span>
                                    <span id="subtotal" class="pull-right float-right">{$subtotal}</span>
                                </div>
                                {if $promotioncode || $taxrate || $taxrate2}
                                    <div class="bordered-totals">
                                        {if $promotioncode}
                                            <div class="clearfix">
                                                <span class="pull-left float-left">{$promotiondescription}</span>
                                                <span id="discount" class="pull-right float-right">{$discount}</span>
                                            </div>
                                        {/if}
                                        {if $taxrate}
                                            <div class="clearfix">
                                                <span class="pull-left float-left">{$taxname} @ {$taxrate}%</span>
                                                <span id="taxTotal1" class="pull-right float-right">{$taxtotal}</span>
                                            </div>
                                        {/if}
                                        {if $taxrate2}
                                            <div class="clearfix">
                                                <span class="pull-left float-left">{$taxname2} @ {$taxrate2}%</span>
                                                <span id="taxTotal2" class="pull-right float-right">{$taxtotal2}</span>
                                            </div>
                                        {/if}
                                    </div>
                                {/if}
                                <div class="recurring-totals clearfix">
                                    <span class="pull-left float-left">{$LANG.orderForm.totals}</span>
                                    <span id="recurring" class="pull-right float-right recurring-charges">
                                        <span id="recurringMonthly" {if !$totalrecurringmonthly}style="display:none;"{/if}>
                                            <span class="cost">{$totalrecurringmonthly}</span> {$LANG.orderpaymenttermmonthly}<br />
                                        </span>
                                        <span id="recurringQuarterly" {if !$totalrecurringquarterly}style="display:none;"{/if}>
                                            <span class="cost">{$totalrecurringquarterly}</span> {$LANG.orderpaymenttermquarterly}<br />
                                        </span>
                                        <span id="recurringSemiAnnually" {if !$totalrecurringsemiannually}style="display:none;"{/if}>
                                            <span class="cost">{$totalrecurringsemiannually}</span> {$LANG.orderpaymenttermsemiannually}<br />
                                        </span>
                                        <span id="recurringAnnually" {if !$totalrecurringannually}style="display:none;"{/if}>
                                            <span class="cost">{$totalrecurringannually}</span> {$LANG.orderpaymenttermannually}<br />
                                        </span>
                                        <span id="recurringBiennially" {if !$totalrecurringbiennially}style="display:none;"{/if}>
                                            <span class="cost">{$totalrecurringbiennially}</span> {$LANG.orderpaymenttermbiennially}<br />
                                        </span>
                                        <span id="recurringTriennially" {if !$totalrecurringtriennially}style="display:none;"{/if}>
                                            <span class="cost">{$totalrecurringtriennially}</span> {$LANG.orderpaymenttermtriennially}<br />
                                        </span>
                                    </span>
                                </div>

                                <div class="total-due-today total-due-today-padded">
                                    <span class="amt" id="totalCartPrice">{$total}</span>
                                    <span>{$LANG.ordertotalduetoday}</span>
                                </div>
                                </div><!-- /.summary-figures -->

                                {if $accepttos}
                                    <p class="text-center accepttos-container">
                                        <label class="checkbox-inline">
                                            <input type="checkbox" name="accepttos" id="accepttos" form="frmCheckout" />
                                            &nbsp;
                                            {$LANG.ordertosagreement}
                                            <a href="{$tosurl}" target="_blank">{$LANG.ordertos}</a>
                                        </label>
                                    </p>
                                {/if}

                                <button type="submit"
                                        id="btnCompleteOrder"
                                        form="frmCheckout"
                                        class="btn btn-primary btn-lg btn-block disable-on-click spinner-on-click{if $captcha}{$captcha->getButtonClass($captchaForm)}{/if}"
                                        {if $cartitems==0}disabled="disabled"{/if}
                                >
                                    {if $inExpressCheckout}{$LANG.confirmAndPay}{else}{$LANG.completeorder}{/if}
                                    &nbsp;<i class="fas fa-arrow-circle-right"></i>
                                </button>


                            </div>
                        </div>
                    </div><!-- /.secondary-cart-sidebar -->
                </div><!-- /.row -->

            {if $servedOverSsl}
                <div class="alert alert-warning checkout-security-msg">
                    <i class="fas fa-lock"></i>
                    {$LANG.ordersecure} (<strong>{$ipaddress}</strong>) {$LANG.ordersecure2}
                    <div class="clearfix"></div>
                </div>
            {/if}
        </div>
    </div>
</div>

<script type="text/javascript" src="{$BASE_PATH_JS}/jquery.payment.js"></script>
<script>
    var hideCvcOnCheckoutForExistingCard = '{if $canUseCreditOnCheckout && $applyCredit && ($creditBalance->toNumeric() >= $total->toNumeric())}1{else}0{/if}';
</script>
<script type="text/javascript" src="{$BASE_PATH_JS}/CartTotalUpdater.js"></script>
<script>
// Re-measure the mailing-list toggle after the layout has fully settled so it
// renders at the correct width inside the narrower column.
// Account-type tabs (promo-tab style): drive the existing slide/show-hide handlers.
(function () {
    var root = document.getElementById('order-standard_cart');
    if (!root || !window.jQuery) { return; }
    jQuery(root).on('click', '.account-type-link', function (e) {
        e.preventDefault();
        var $link = jQuery(this);
        if ($link.hasClass('active')) { return; }
        $link.closest('.nav-tabs').find('.nav-item, .nav-link').removeClass('active');
        $link.addClass('active').closest('.nav-item').addClass('active');
        if ($link.attr('data-account-type') === 'existing') {
            jQuery('#btnAlreadyRegistered').trigger('click');
        } else {
            jQuery('#btnNewUserSignup').trigger('click');
        }
    });
})();

jQuery(window).on('load', function () {
    if (jQuery.prototype.bootstrapSwitch) {
        var $optin = jQuery('.marketing-email-optin .toggle-switch-success');
        if ($optin.length) {
            $optin.bootstrapSwitch('destroy');
            $optin.bootstrapSwitch({ onColor: 'success' });
        }
    }
});

// ---------------------------------------------------------------------------
// Single-page cart editing (original implementation).
//
// standard_cart's cart edits (apply promo, change quantity, remove, empty,
// estimate tax) are normal form posts that 302 to ?a=view. This intercepts
// those submits, performs them in the background, then re-fetches the rendered
// checkout page and swaps the two parts that changed -- the cart review and the
// order-summary figures -- in place. The checkout form fields and the customer's
// progress are never touched.
//
// It degrades gracefully: on any failure (or an old browser) it falls back to
// the normal submit, and the companion return hook brings the customer back to
// checkout, so the cart can never get stuck.
// ---------------------------------------------------------------------------
(function () {
    var root = document.getElementById('order-standard_cart');
    if (!root || !window.fetch || !window.FormData || !window.DOMParser) {
        return; // unsupported browser -> native form behaviour
    }

    var CHECKOUT_URL = 'cart.php?a=checkout&e=false';

    function setBusy(on) {
        var loader = document.getElementById('orderSummaryLoader');
        if (loader) { loader.classList.toggle('w-hidden', !on); }
        var review = root.querySelector('.cart-review-merged');
        if (review) {
            review.style.opacity = on ? '0.5' : '';
            review.style.pointerEvents = on ? 'none' : '';
        }
    }

    function reinitInputs(scope) {
        try {
            if (window.jQuery && window.jQuery.fn.iCheck) {
                window.jQuery(scope).find('input').not('.no-icheck').iCheck({
                    checkboxClass: 'icheckbox_square-blue',
                    radioClass: 'iradio_square-blue',
                    increaseArea: '20%'
                });
            }
        } catch (err) { /* non-fatal */ }
    }

    // Apply a cart edit:
    //  1) swap the review from the EDIT response -- this is what carries WHMCS's
    //     promo "accepted" / "invalid code" message, set only on the request
    //     that processed the promo;
    //  2) refresh the order-summary figures from a fresh checkout render, so the
    //     totals are correct and rows (discount, tax) appear/disappear cleanly.
    function applyEdit(editResponseHtml) {
        var d1 = new DOMParser().parseFromString(editResponseHtml, 'text/html');
        var src = d1.querySelector('.cart-review-merged') || d1.querySelector('.secondary-cart-body');
        var curReview = root.querySelector('.cart-review-merged');
        if (!curReview) { throw new Error('cart review container missing'); }
        if (src) { curReview.innerHTML = src.innerHTML; reinitInputs(curReview); }

        return fetch(CHECKOUT_URL, { credentials: 'same-origin' })
            .then(function (r) { return r.text(); })
            .then(function (checkoutHtml) {
                var d2 = new DOMParser().parseFromString(checkoutHtml, 'text/html');
                var review = root.querySelector('.cart-review-merged');
                var isEmpty = !(review && review.querySelector('.view-cart-items .item'));

                var newFigs = d2.querySelector('.summary-figures');
                var curFigs = root.querySelector('.summary-figures');
                if (newFigs && curFigs) {
                    // Normal: checkout re-rendered -> swap the figures wholesale.
                    curFigs.innerHTML = newFigs.innerHTML;
                } else if (isEmpty && curFigs) {
                    // Empty cart: ?a=checkout redirects to ?a=view (no .summary-figures).
                    // Pull the $0 totals from that page and trim the discount / tax /
                    // recurring rows so nothing stays stuck at the old amount.
                    var z = d2.getElementById('subtotal') || d2.getElementById('totalDueToday');
                    var zero = z ? z.innerHTML : '';
                    var sub = curFigs.querySelector('#subtotal');
                    var tot = curFigs.querySelector('#totalCartPrice');
                    if (sub && zero) { sub.innerHTML = zero; }
                    if (tot && zero) { tot.innerHTML = zero; }
                    var bt = curFigs.querySelector('.bordered-totals'); if (bt) { bt.style.display = 'none'; }
                    var rt = curFigs.querySelector('.recurring-totals'); if (rt) { rt.style.display = 'none'; }
                }

                // When the cart is empty, hide the sign-up / payment form and the
                // TOS line, and disable the button; restore them otherwise.
                var form = document.getElementById('frmCheckout');
                if (form) { form.style.display = isEmpty ? 'none' : ''; }
                var tos = document.querySelector('.accepttos-container');
                if (tos) { tos.style.display = isEmpty ? 'none' : ''; }
                var btn = document.getElementById('btnCompleteOrder');
                if (btn) { btn.disabled = isEmpty; }
            });
    }

    root.addEventListener('submit', function (e) {
        var form = e.target;
        if (!form || form.id === 'frmCheckout') { return; }            // leave checkout alone
        if ((form.getAttribute('action') || '').indexOf('cart.php') === -1) { return; }

        e.preventDefault();
        setBusy(true);

        var fd = new FormData(form);
        if (e.submitter && e.submitter.name) {                          // include the clicked button
            fd.append(e.submitter.name, e.submitter.value || '');
        }

        fetch(form.action, { method: 'POST', credentials: 'same-origin', body: fd })
            .then(function (r) { return r.text(); })
            .then(function (editResponseHtml) { return applyEdit(editResponseHtml); })
            .then(function () {
                setBusy(false);
                if (window.jQuery) { window.jQuery('#modalRemoveItem, #modalEmptyCart').modal('hide'); }
            })
            .catch(function () {
                // Fallback: native submit + flag so the return hook restores checkout.
                document.cookie = 'cartReturnToCheckout=1; path=/; max-age=30';
                form.submit();
            });
    }, true);

    // Promo removal is a link (a=removepromo), not a form, so the submit handler
    // never sees it. Intercept the click and run it through the same in-place
    // update so it no longer bounces to View Cart.
    root.addEventListener('click', function (e) {
        var a = (e.target && e.target.closest) ? e.target.closest('a[href*="a=removepromo"]') : null;
        if (!a) { return; }
        e.preventDefault();
        setBusy(true);
        fetch(a.href, { credentials: 'same-origin' })
            .then(function (r) { return r.text(); })
            .then(function (editResponseHtml) { return applyEdit(editResponseHtml); })
            .then(function () {
                setBusy(false);
                if (window.jQuery) { window.jQuery('#modalRemoveItem, #modalEmptyCart').modal('hide'); }
            })
            .catch(function () {
                document.cookie = 'cartReturnToCheckout=1; path=/; max-age=30';
                window.location.href = a.href;
            });
    }, true);
})();
</script>
{include file="orderforms/standard_cart/recommendations-modal.tpl"}