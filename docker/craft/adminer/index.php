<?php

function adminer_object()
{

    class AdminerSoftware extends Adminer
    {

        function name()
        {
            // custom name in title and heading
            return 'Welance: '.getenv('CRAFT_SITENAME').' DB';
        }

        function importServerPath()
        {
            $path = realpath("/data/craft/config/database-seed.sql");
            return $path;
        }

        function loginForm()
        {
            global $drivers;

            // this is a bit weird but neverthe less
            $driver = getenv("DB_DRIVER") == "mysql" ? "server" : getenv("DB_DRIVER");

            echo ('<input type="hidden" name="auth[driver]" value="' . $driver . '"></input>');
            echo ('<input type="hidden" name="auth[server]" value="' . getenv("DB_SERVER") . '"></input>');
            echo ('<input type="hidden" name="auth[username]" value="' . getenv("DB_USER") . '"></input>');
            echo ('<input type="hidden" name="auth[password]" value="' . getenv("DB_PASSWORD") . '"></input>');
            echo ('<input type="hidden" name="auth[db]" value="' . getenv("DB_DATABASE") . '"></input>');

            echo ('<table cellspacing="0">');
            echo ("<tr><th>" . lang('System') . "</th><td>" . getenv("DB_DRIVER") . "</td></tr>");
            echo ("<tr><th>" . lang('Server') . "</th><td>" . getenv("DB_SERVER") . "</td></tr>");
            echo ("<tr><th>" . lang('Username') . "</th><td>" . getenv("DB_USER") . "</td></tr>");
            echo ("<tr><th>" . lang('Password') . "</th><td>************</td></tr>");
            echo ("<tr><th>" . lang('Database') . "</th><td>" . getenv("DB_DATABASE") . "</td></tr>");
            echo ('</table>');

            echo script("focus(qs('#username'));");
            echo "<p><input type='submit' value='" . lang('Login') . "'>\n";
            echo checkbox("auth[permanent]", 1, $_COOKIE["adminer_permanent"], lang('Permanent login')) . "\n";
        }

    }

    return new AdminerSoftware;
}

include "./adminer-4.6.2-en.php";
