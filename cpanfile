requires 'perl', '5.008001';
requires 'JSON';
requires 'Text::CSV';

on 'test' => sub {
    requires 'Test::More', '0.98';
};

