<?php





/**
eral Configuration
 *
 * All of your system's general configuration settings go in here. You can see a
 * list of the available settings in vendor/craftcms/cms/src/config/GeneralConfig.php.
 */
return [
    // Global settings
    '*' => [
        // Default Week Start Day (0 = Sunday, 1 = Monday...)
        'defaultWeekStartDay' => 1,
        // Enable CSRF Protection (recommended, will be enabled by default in Craft 3)
        'enableCsrfProtection' => true,
        // Whether "index.php" should be visible in URLs
        'omitScriptNameInUrls' => true,
        // Control Panel trigger word
        'cpTrigger' => 'admin',
        // The secure key Craft will use for hashing and encrypting data
        'securityKey' => getenv('SECURITY_KEY'),
        'environmentVariables' => array(
            'baseUrl'  => getenv('CRAFT_SITEURL'),
            'assetsBaseUrl'  => getenv('CRAFT_SITEURL')+"/assets"
        ),
    ],
    // Dev environment settings
    'dev' => [
        // Base site URL
        'siteUrl' => getenv('CRAFT_SITEURL'),
        // Dev Mode (see https://craftcms.com/support/dev-mode)
        'devMode' => true,
    ],
    // Staging environment settings
    'staging' => [
        // Base site URL
        'siteUrl' => getenv('CRAFT_SITEURL'),
    ],
    // Production environment settings
    'production' => [
        // Base site URL
        'siteUrl' => getenv('CRAFT_SITEURL'),
    ],
];

