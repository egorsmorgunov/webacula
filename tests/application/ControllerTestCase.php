<?php
/**
 * Copyright 2009, 2010 Yuri Timofeev tim4dev@gmail.com
 * @author Yuri Timofeev <tim4dev@gmail.com>
 * @package webacula
 * @license http://www.gnu.org/licenses/gpl-3.0.html GNU Public License
 */
require_once 'Zend/Application.php';
require_once 'Zend/Test/PHPUnit/ControllerTestCase.php';

/**
 * Controller Test case
 *
 * @category Tests
 */
abstract class ControllerTestCase extends Zend_Test_PHPUnit_ControllerTestCase
{
	protected $_application;

	public function setUp() {
		$this->bootstrap = array ($this, 'appBootstrap' );
		parent::setUp();
	}

	/**
	 * Boostrap Application
	 */
	public function appBootstrap() {
		$this->_application = new Zend_Application ( APPLICATION_PATH );
		$this->frontController->addControllerDirectory ( APPLICATION_PATH . '/controllers' );
		$this->_application->bootstrap();
	}


	protected function _doRootLogin()    {
		// php array to object
        $data = (object)$arr = array(
          'id'        => 1000,
          'login'     => 'root',
          'role_id'   => 1,
          'role_name' => 'root_role'
        );
        // wtite session
        $auth = Zend_Auth::getInstance();
        $storage = $auth->getStorage();
        $storage->write($data);
        Zend_Session::rememberMe();
    }

}
